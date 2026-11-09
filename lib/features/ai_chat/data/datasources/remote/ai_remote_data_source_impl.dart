import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/core/const/api_headers.dart';
import 'package:super_fitness/core/const/api_params.dart';
import 'package:super_fitness/features/ai_chat/core/constants/ai_constants.dart';
import 'package:super_fitness/features/ai_chat/core/constants/tool_names.dart';
import 'package:super_fitness/features/ai_chat/core/utils/platform_host_resolver.dart';
import 'package:super_fitness/features/ai_chat/core/utils/safe_bool_parser.dart';
import 'package:super_fitness/features/ai_chat/core/utils/system_prompt_builder.dart';
import 'package:super_fitness/features/ai_chat/core/utils/thought_parser.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/contract/ai_remote_data_source.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/contract/fitness_local_data_source.dart';
import 'package:super_fitness/features/ai_chat/data/models/chat_message_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/chat_session_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/structured_fitness_card_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/tool_call_model.dart';
import 'package:super_fitness/features/ai_chat/data/tools/definitions/tool_definitions.dart';

@LazySingleton(as: AiRemoteDataSource)
class AiRemoteDataSourceImpl implements AiRemoteDataSource {
  final Dio _dio;
  final FirebaseFirestore _firestore;
  final FirebaseAuth _firebaseAuth;
  final SessionService _sessionService;
  final FitnessLocalDataSource _localDbDataSource;

  AiRemoteDataSourceImpl({
    required this._dio,
    required this._sessionService,
    required this._localDbDataSource,
    required this._firestore,
    required this._firebaseAuth,
  });

  String get _ollamaUrl => PlatformHostResolver.resolveChatEndpoint();

  String _resolveUserId() {
    final fbUser = _firebaseAuth.currentUser;
    if (fbUser != null && fbUser.uid.isNotEmpty) {
      return fbUser.uid;
    }
    return 'default_user';
  }

  CollectionReference<Map<String, dynamic>> _sessionsCollection() {
    final uid = _resolveUserId();
    return _firestore
        .collection(AiConstants.usersCollection)
        .doc(uid)
        .collection(AiConstants.chatSessionsCollection);
  }

  DocumentReference<Map<String, dynamic>> _sessionDoc(String sessionId) {
    return _sessionsCollection().doc(sessionId);
  }

  CollectionReference<Map<String, dynamic>> _messagesCollection(
    String sessionId,
  ) {
    return _sessionDoc(sessionId).collection(AiConstants.messagesCollection);
  }

  static String _generateSessionTitle(String raw) {
    final collapsed = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (collapsed.isEmpty) return 'New Chat';
    final capitalized = collapsed[0].toUpperCase() + collapsed.substring(1);
    if (capitalized.length > 28) {
      return '${capitalized.substring(0, 28)}...';
    }
    return capitalized;
  }

  Future<void> _updateSessionMetadata({
    required String sessionId,
    String? firstUserMessage,
    int addedTokens = 0,
  }) async {
    try {
      final doc = _sessionDoc(sessionId);
      final snapshot = await doc.get().timeout(AiConstants.firestoreTimeout);
      final data = snapshot.data();

      final existingTitle = data?[ApiParams.title] as String?;
      final isGeneric =
          existingTitle == null ||
          existingTitle.isEmpty ||
          existingTitle == 'New Chat' ||
          existingTitle.startsWith('Chat ');

      String title = existingTitle ?? '';
      if (isGeneric &&
          firstUserMessage != null &&
          firstUserMessage.trim().isNotEmpty) {
        title = _generateSessionTitle(firstUserMessage);
      } else if (title.isEmpty) {
        title = 'New Chat';
      }

      await doc
          .set({
            ApiParams.title: title,
            if (!snapshot.exists)
              ApiParams.createdAt: FieldValue.serverTimestamp(),
            ApiParams.updatedAt: FieldValue.serverTimestamp(),
            ApiParams.totalTokens: FieldValue.increment(addedTokens),
          }, SetOptions(merge: true))
          .timeout(AiConstants.firestoreTimeout);
    } catch (e) {
      debugPrint('[AiChat] Failed to update session metadata: $e');
    }
  }

  Future<void> _safeSaveMessage(
    String sessionId,
    Map<String, dynamic> data,
  ) async {
    try {
      await _messagesCollection(
        sessionId,
      ).add(data).timeout(AiConstants.firestoreTimeout);
    } catch (e) {
      debugPrint('[AiChat] Firestore message save skipped: $e');
    }
  }

  @override
  Future<ChatMessageModel> sendMessage({
    required String message,
    required String sessionId,
  }) async {
    final userMessageModel = ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: 'user',
      content: message,
      timestamp: DateTime.now(),
    );

    await _safeSaveMessage(sessionId, userMessageModel.toFirestoreMap());

    final List<ChatMessageModel> history = await getChatHistory(
      sessionId: sessionId,
    );

    final systemPrompt = await SystemPromptBuilder.buildPrompt(
      sessionService: _sessionService,
      firebaseAuth: _firebaseAuth,
    );

    final List<Map<String, dynamic>> contextMessages = [
      {ApiParams.role: 'system', ApiParams.content: systemPrompt},
    ];

    for (final m in history) {
      if (m.content.isNotEmpty) {
        contextMessages.add(m.toOllamaJson());
      }
    }

    contextMessages.add(userMessageModel.toOllamaJson());

    try {
      debugPrint(
        '[AiChat] Sending request to Ollama: $_ollamaUrl (Model: ${AiConstants.defaultModel})',
      );
      final response = await _dio.post(
        _ollamaUrl,
        data: {
          ApiParams.model: AiConstants.defaultModel,
          ApiParams.messages: contextMessages,
          ApiParams.stream: false,
          ApiParams.tools: ToolDefinitions.tools,
        },
        options: Options(
          headers: {ApiHeaders.contentType: ApiHeaders.applicationJson},
          sendTimeout: AiConstants.requestTimeout,
          receiveTimeout: AiConstants.receiveTimeout,
        ),
      );

      final rawData = response.data;
      final Map<String, dynamic> dataMap = rawData is String
          ? jsonDecode(rawData) as Map<String, dynamic>
          : (rawData as Map<String, dynamic>? ?? {});

      final messageMap = (dataMap['message'] as Map<String, dynamic>?) ?? {};
      final phase1Message = ChatMessageModel.fromOllamaJson(messageMap);

      if (phase1Message.toolCalls.isNotEmpty) {
        debugPrint(
          '[AiChat] Detected ${phase1Message.toolCalls.length} tool calls. Initiating Phase 2.',
        );
        return await _executePhase2ToolFlow(
          phase1Message: phase1Message,
          contextMessages: contextMessages,
          sessionId: sessionId,
        );
      }

      final cleanPhase1Content = ThoughtParser.stripThinkingTags(
        phase1Message.content,
      );
      final assistantMessage = ChatMessageModel(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: 'assistant',
        content: cleanPhase1Content.isNotEmpty
            ? cleanPhase1Content
            : 'I am here to help you achieve your athletic potential! What workout or meal plan can I detail for you today?',
        timestamp: DateTime.now(),
      );

      await _safeSaveMessage(sessionId, assistantMessage.toFirestoreMap());
      final promptTokens = (dataMap['prompt_eval_count'] as int?) ?? 0;
      final evalTokens = (dataMap['eval_count'] as int?) ?? 0;
      final total = promptTokens + evalTokens > 0
          ? (promptTokens + evalTokens)
          : ((message.length + assistantMessage.content.length) / 4).ceil();
      await _updateSessionMetadata(
        sessionId: sessionId,
        firstUserMessage: message,
        addedTokens: total,
      );
      return assistantMessage;
    } catch (e, st) {
      debugPrint('[AiChat] Error contacting Ollama at $_ollamaUrl: $e\n$st');
      debugPrint('[AiChat] Engaging local database fallback harness.');
      return await _fallbackLocalHarness(
        userMessage: message,
        sessionId: sessionId,
      );
    }
  }

  @override
  Stream<ChatMessageModel> streamMessage({
    required String message,
    required String sessionId,
  }) async* {
    final userMessageModel = ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: 'user',
      content: message,
      timestamp: DateTime.now(),
    );

    await _safeSaveMessage(sessionId, userMessageModel.toFirestoreMap());

    final List<ChatMessageModel> history = await getChatHistory(
      sessionId: sessionId,
    );
    final systemPrompt = await SystemPromptBuilder.buildPrompt(
      sessionService: _sessionService,
      firebaseAuth: _firebaseAuth,
    );

    final List<Map<String, dynamic>> contextMessages = [
      {ApiParams.role: 'system', ApiParams.content: systemPrompt},
    ];

    for (final m in history) {
      if (m.content.isNotEmpty) {
        contextMessages.add(m.toOllamaJson());
      }
    }
    contextMessages.add(userMessageModel.toOllamaJson());

    final assistantMsgId = DateTime.now().microsecondsSinceEpoch.toString();

    try {
      debugPrint(
        '[AiChat] Streaming request to Ollama: $_ollamaUrl (stream: true)',
      );
      final response = await _dio.post<ResponseBody>(
        _ollamaUrl,
        data: {
          ApiParams.model: AiConstants.defaultModel,
          ApiParams.messages: contextMessages,
          ApiParams.stream: true,
          ApiParams.tools: ToolDefinitions.tools,
        },
        options: Options(
          responseType: ResponseType.stream,
          headers: {ApiHeaders.contentType: ApiHeaders.applicationJson},
          sendTimeout: AiConstants.requestTimeout,
          receiveTimeout: AiConstants.receiveTimeout,
        ),
      );

      final stream = response.data?.stream;
      if (stream != null) {
        final lineStream = utf8.decoder
            .bind(stream)
            .transform(const LineSplitter());
        final List<ToolCallModel> streamedToolCalls = [];
        var rawAccumulated = '';
        var accumulatedThinking = '';

        await for (final line in lineStream) {
          if (line.trim().isEmpty) continue;
          try {
            final Map<String, dynamic> json =
                jsonDecode(line) as Map<String, dynamic>;
            final messageMap = (json['message'] as Map<String, dynamic>?) ?? {};
            final delta = (messageMap[ApiParams.content] as String?) ?? '';
            final thinkingDelta = (messageMap['thinking'] as String?) ?? '';
            final done = safeBool(json['done']) ?? false;

            final rawTools = messageMap[ApiParams.toolCalls];
            if (rawTools is List && rawTools.isNotEmpty) {
              for (final t in rawTools) {
                if (t is Map<String, dynamic>) {
                  streamedToolCalls.add(ToolCallModel.fromJson(t));
                }
              }
            }

            if (delta.isNotEmpty || thinkingDelta.isNotEmpty) {
              rawAccumulated += delta;
              if (thinkingDelta.isNotEmpty) {
                accumulatedThinking += thinkingDelta;
              }

              final parsed = ThoughtParser.parseStream(
                rawAccumulated: rawAccumulated,
                accumulatedThinking: accumulatedThinking,
              );

              yield ChatMessageModel(
                id: assistantMsgId,
                role: 'assistant',
                content: parsed.content,
                thought: parsed.rawThought,
                thinkingStatus: parsed.activeStep,
                timestamp: DateTime.now(),
              );
            }

            if (done) {
              if (streamedToolCalls.isNotEmpty) {
                final phase1 = ChatMessageModel(
                  id: assistantMsgId,
                  role: 'assistant',
                  content: rawAccumulated,
                  timestamp: DateTime.now(),
                  toolCalls: streamedToolCalls,
                );
                final phase2Result = await _executePhase2ToolFlow(
                  phase1Message: phase1,
                  contextMessages: contextMessages,
                  sessionId: sessionId,
                );
                yield phase2Result;
                return;
              }
              break;
            }
          } catch (_) {}
        }

        final parsedFinal = ThoughtParser.parseStream(
          rawAccumulated: rawAccumulated,
          accumulatedThinking: accumulatedThinking,
        );

        final cleanFinalContent = parsedFinal.content.isNotEmpty
            ? parsedFinal.content
            : (parsedFinal.rawThought?.isNotEmpty == true
                  ? 'I have analyzed your request based on your fitness goals.'
                  : 'I am here to help you achieve your athletic potential! What workout or meal plan can I detail for you today?');

        final finalMsg = ChatMessageModel(
          id: assistantMsgId,
          role: 'assistant',
          content: cleanFinalContent,
          thought: parsedFinal.rawThought,
          thinkingStatus: null,
          timestamp: DateTime.now(),
        );
        await _safeSaveMessage(sessionId, finalMsg.toFirestoreMap());
        final estimatedTokens = ((message.length + finalMsg.content.length) / 4)
            .ceil();
        await _updateSessionMetadata(
          sessionId: sessionId,
          firstUserMessage: message,
          addedTokens: estimatedTokens,
        );
        yield finalMsg;
        return;
      }
    } catch (e) {
      debugPrint(
        '[AiChat] Streaming Ollama error: $e. Falling back to local harness.',
      );
    }

    final fallbackModel = await _fallbackLocalHarness(
      userMessage: message,
      sessionId: sessionId,
    );

    const fallbackThought =
        'Analyzing workout routines, target muscle groups, and metabolic targets...';
    yield ChatMessageModel(
      id: fallbackModel.id,
      role: 'assistant',
      content: '',
      thought: fallbackThought,
      timestamp: fallbackModel.timestamp,
    );
    await Future<void>.delayed(const Duration(milliseconds: 250));

    final words = fallbackModel.content.split(' ');
    var fallbackAccumulated = '';
    for (var i = 0; i < words.length; i++) {
      fallbackAccumulated += (i == 0 ? '' : ' ') + words[i];
      yield ChatMessageModel(
        id: fallbackModel.id,
        role: 'assistant',
        content: fallbackAccumulated,
        thought: fallbackThought,
        timestamp: fallbackModel.timestamp,
        fitnessCard: i == words.length - 1 ? fallbackModel.fitnessCard : null,
      );
      await Future<void>.delayed(const Duration(milliseconds: 25));
    }
  }

  Future<ChatMessageModel> _executePhase2ToolFlow({
    required ChatMessageModel phase1Message,
    required List<Map<String, dynamic>> contextMessages,
    required String sessionId,
  }) async {
    StructuredFitnessCardModel? structuredCard;
    final List<Map<String, dynamic>> toolResultContext = List.from(
      contextMessages,
    );

    toolResultContext.add({
      ApiParams.role: 'assistant',
      ApiParams.content: phase1Message.content,
      ApiParams.toolCalls: phase1Message.toolCalls
          .map((t) => t.toJson())
          .toList(),
    });

    for (final toolCall in phase1Message.toolCalls) {
      final name = toolCall.function.name;
      final args = toolCall.function.arguments;
      debugPrint('[AiChat] Executing tool: $name with args: $args');

      Map<String, dynamic> toolResult = {};
      if (name == ToolNames.getExerciseDetails) {
        final exerciseName =
            (args[ToolNames.paramExerciseName] as String?) ?? 'Exercise';
        final targetMuscle = args[ToolNames.paramTargetMuscle] as String?;
        toolResult = await _localDbDataSource.getExerciseDetails(
          exerciseName: exerciseName,
          targetMuscle: targetMuscle,
        );
      } else if (name == ToolNames.getMealNutrition) {
        final mealName = (args[ToolNames.paramMealName] as String?) ?? 'Meal';
        final goal = args[ToolNames.paramGoal] as String?;
        toolResult = await _localDbDataSource.getMealNutrition(
          mealName: mealName,
          goal: goal,
        );
      }

      structuredCard = StructuredFitnessCardModel.fromJson(toolResult);

      toolResultContext.add({
        ApiParams.role: 'tool',
        ApiParams.content: jsonEncode(toolResult),
      });
    }

    String finalContent = '';
    try {
      final phase2Response = await _dio.post(
        _ollamaUrl,
        data: {
          ApiParams.model: AiConstants.defaultModel,
          ApiParams.messages: toolResultContext,
          ApiParams.stream: false,
        },
        options: Options(
          headers: {ApiHeaders.contentType: ApiHeaders.applicationJson},
          sendTimeout: AiConstants.requestTimeout,
          receiveTimeout: AiConstants.receiveTimeout,
        ),
      );

      final rawPhase2 = phase2Response.data;
      final Map<String, dynamic> phase2Data = rawPhase2 is String
          ? jsonDecode(rawPhase2) as Map<String, dynamic>
          : (rawPhase2 as Map<String, dynamic>? ?? {});

      final rawFinal = phase2Data['message'] as Map<String, dynamic>? ?? {};
      finalContent = (rawFinal[ApiParams.content] as String?) ?? '';
    } catch (e) {
      debugPrint('[AiChat] Phase 2 synthesis fallback: $e');
      finalContent = structuredCard != null
          ? 'Here are the personalized details for ${structuredCard.title}:'
          : 'Here is your fitness recommendation:';
    }

    final synthesizedMessage = ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: 'assistant',
      content: finalContent.isNotEmpty
            ? finalContent
            : 'Here is the requested breakdown for your training:',
      timestamp: DateTime.now(),
      fitnessCard: structuredCard,
    );

    await _safeSaveMessage(sessionId, synthesizedMessage.toFirestoreMap());
    return synthesizedMessage;
  }

  Future<ChatMessageModel> _fallbackLocalHarness({
    required String userMessage,
    required String sessionId,
  }) async {
    final lower = userMessage.toLowerCase();
    StructuredFitnessCardModel? card;
    String replyText = '';

    try {
      if (lower.contains('squat') ||
          lower.contains('bench') ||
          lower.contains('deadlift') ||
          lower.contains('exercise') ||
          lower.contains('workout') ||
          lower.contains('train')) {
        final exerciseName = lower.contains('bench')
            ? 'bench press'
            : lower.contains('squat')
            ? 'squat'
            : lower.contains('deadlift')
            ? 'deadlift'
            : 'bench press';
        final res = await _localDbDataSource.getExerciseDetails(
          exerciseName: exerciseName,
        );
        card = StructuredFitnessCardModel.fromJson(res);
        replyText =
            'I have analyzed your workout query and retrieved the exact training mechanics from our exercise database:';
      } else if (lower.contains('chicken') ||
          lower.contains('oat') ||
          lower.contains('salmon') ||
          lower.contains('meal') ||
          lower.contains('diet') ||
          lower.contains('food') ||
          lower.contains('nutrition') ||
          lower.contains('calor')) {
        final mealName = lower.contains('oat')
            ? 'oatmeal'
            : lower.contains('salmon')
            ? 'salmon'
            : 'chicken';
        final res = await _localDbDataSource.getMealNutrition(mealName: mealName);
        card = StructuredFitnessCardModel.fromJson(res);
        replyText =
            'I have pulled the nutritional breakdown and macro profile for your goal:';
      } else {
        replyText =
            'Hello! I am your Smart Coach. Ask me about any workout (e.g. bench press, squats) or nutrition plans (e.g. high protein chicken, oats, salmon) to get real-time athletic guidance!';
      }
    } catch (e, st) {
      debugPrint('[AiChat] Error in fallback local harness database lookup: $e\n$st');
      card = null;
      replyText =
          'I am your Smart Coach. I am temporarily operating in offline mode. Ask me about any workout or meal plan to get guidance!';
    }

    final messageModel = ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: 'assistant',
      content: replyText,
      timestamp: DateTime.now(),
      fitnessCard: card,
    );

    await _safeSaveMessage(sessionId, messageModel.toFirestoreMap());
    final total = ((userMessage.length + messageModel.content.length) / 4)
        .ceil();
    await _updateSessionMetadata(
      sessionId: sessionId,
      firstUserMessage: userMessage,
      addedTokens: total,
    );
    return messageModel;
  }

  @override
  Future<List<ChatMessageModel>> getChatHistory({
    required String sessionId,
  }) async {
    try {
      final snapshot = await _messagesCollection(sessionId)
          .orderBy(ApiParams.timestamp, descending: false)
          .get()
          .timeout(AiConstants.firestoreTimeout);

      return snapshot.docs
          .map((doc) => ChatMessageModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('[AiChat] Firestore getChatHistory skipped: $e');
      return [];
    }
  }

  @override
  Future<void> clearChatHistory({required String sessionId}) async {
    try {
      final snapshot = await _messagesCollection(
        sessionId,
      ).get().timeout(AiConstants.firestoreTimeout);
      final batch = _firestore.batch();
      for (final doc in snapshot.docs) {
        batch.delete(doc.reference);
      }
      await batch.commit().timeout(AiConstants.firestoreTimeout);
    } catch (e) {
      debugPrint('[AiChat] Firestore clearChatHistory skipped: $e');
    }
  }

  @override
  Future<List<ChatSessionModel>> getChatSessions() async {
    try {
      final snapshot = await _sessionsCollection()
          .orderBy(ApiParams.updatedAt, descending: true)
          .get()
          .timeout(AiConstants.firestoreTimeout);

      return snapshot.docs
          .map((doc) => ChatSessionModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      debugPrint('[AiChat] getChatSessions error: $e');
      return [];
    }
  }

  @override
  Future<ChatSessionModel> createNewSession({String? title}) async {
    final sessionDoc = _sessionsCollection().doc();
    final now = DateTime.now();
    final resolvedTitle = title ?? 'New Chat';

    final model = ChatSessionModel(
      id: sessionDoc.id,
      title: resolvedTitle,
      createdAt: now,
      updatedAt: now,
      totalTokens: 0,
    );

    try {
      await sessionDoc
          .set(model.toFirestoreMap())
          .timeout(AiConstants.firestoreTimeout);
    } catch (e) {
      debugPrint('[AiChat] createNewSession error: $e');
    }

    return model;
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    try {
      final messages = await _messagesCollection(
        sessionId,
      ).get().timeout(AiConstants.firestoreTimeout);
      final batch = _firestore.batch();
      for (final doc in messages.docs) {
        batch.delete(doc.reference);
      }
      batch.delete(_sessionDoc(sessionId));
      await batch.commit().timeout(AiConstants.firestoreTimeout);
    } catch (e) {
      debugPrint('[AiChat] deleteSession error: $e');
    }
  }
}
