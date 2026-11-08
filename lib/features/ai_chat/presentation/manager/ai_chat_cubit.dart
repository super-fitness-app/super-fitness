import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_session_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/clear_chat_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/create_new_session_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/delete_session_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/get_chat_history_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/get_chat_sessions_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/send_message_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/stream_message_use_case.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_event.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_state.dart';

@injectable
class AiChatCubit extends BaseCubit<AiChatState, BaseEvent> {
  final SendMessageUseCase _sendMessageUseCase;
  final GetChatHistoryUseCase _getChatHistoryUseCase;
  final ClearChatUseCase _clearChatUseCase;
  final SessionService _sessionService;
  final FirebaseAuth _firebaseAuth;
  final StreamMessageUseCase? _streamMessageUseCase;
  final GetChatSessionsUseCase? _getChatSessionsUseCase;
  final CreateNewSessionUseCase? _createNewSessionUseCase;
  final DeleteSessionUseCase? _deleteSessionUseCase;

  String _currentSessionId = 'default_session';

  AiChatCubit(
    this._sendMessageUseCase,
    this._getChatHistoryUseCase,
    this._clearChatUseCase,
    this._sessionService,
    this._firebaseAuth, [
    this._streamMessageUseCase,
    this._getChatSessionsUseCase,
    this._createNewSessionUseCase,
    this._deleteSessionUseCase,
  ]) : super(const AiChatState()) {
    _resolveAthleteName();
    _onLoadSessions();
  }

  @override
  void doEvent(Object event) {
    switch (event) {
      case LoadChatHistoryEvent(:final sessionId):
        _onLoadHistory(sessionId);
      case SendChatMessageEvent(:final message, :final sessionId):
        _onSendMessage(message, sessionId);
      case ClearChatHistoryEvent(:final sessionId):
        _onClearHistory(sessionId);
      case LoadChatSessionsEvent():
        _onLoadSessions();
      case SelectChatSessionEvent(:final sessionId):
        _onSelectSession(sessionId);
      case CreateNewSessionEvent(:final title):
        _onCreateNewSession(title);
      case DeleteChatSessionEvent(:final sessionId):
        _onDeleteSession(sessionId);
      default:
        break;
    }
  }

  Future<void> _resolveAthleteName() async {
    try {
      final raw = await _sessionService.getUserData();
      if (raw.isNotEmpty) {
        final data = jsonDecode(raw);
        if (data is Map<String, dynamic>) {
          final name = data['firstName'] ?? data['name'] ?? 'Athlete';
          emit(state.copyWith(userName: name.toString()));
          return;
        }
      }
      final user = _firebaseAuth.currentUser;
      if (user?.displayName?.isNotEmpty == true) {
        emit(state.copyWith(userName: user!.displayName!));
      }
    } catch (_) {}
  }

  Future<void> _onLoadSessions() async {
    final useCase = _getChatSessionsUseCase;
    if (useCase == null) return;
    emit(state.copyWith(sessionsState: BaseState.loading()));
    final result = await useCase();
    switch (result) {
      case Success(:final data):
        final matching = data.where((s) => s.id == _currentSessionId).firstOrNull;
        final resolvedSessions = data.map((remote) {
          final local = state.sessions.where((s) => s.id == remote.id).firstOrNull;
          if (local != null &&
              local.title != 'New Chat' &&
              !local.title.startsWith('Chat ') &&
              (remote.title == 'New Chat' || remote.title.startsWith('Chat '))) {
            return remote.copyWith(title: local.title);
          }
          return remote;
        }).toList();

        emit(state.copyWith(
          sessionsState: BaseState.success(data),
          sessions: resolvedSessions,
          currentSessionTokens: matching?.totalTokens ?? state.currentSessionTokens,
        ));
      case FailureResponse(:final failure):
        emit(state.copyWith(sessionsState: BaseState.failure(failure)));
    }
  }

  Future<void> _onSelectSession(String sessionId) async {
    _currentSessionId = sessionId;
    final matching = state.sessions.where((s) => s.id == sessionId).firstOrNull;
    emit(state.copyWith(
      currentSessionId: sessionId,
      currentSessionTokens: matching?.totalTokens ?? 0,
      isHistoryLoading: true,
      messages: const [],
    ));
    await _onLoadHistory(sessionId);
  }

  Future<void> _onCreateNewSession(String? title) async {
    final useCase = _createNewSessionUseCase;
    if (useCase == null) {
      final newId = 'session_${DateTime.now().millisecondsSinceEpoch}';
      _currentSessionId = newId;
      emit(state.copyWith(
        currentSessionId: newId,
        currentSessionTokens: 0,
        messages: const [],
      ));
      return;
    }

    final result = await useCase(title: title);
    switch (result) {
      case Success(:final data):
        _currentSessionId = data.id;
        final list = List<ChatSessionEntity>.from(state.sessions)..insert(0, data);
        emit(state.copyWith(
          currentSessionId: data.id,
          currentSessionTokens: 0,
          messages: const [],
          sessions: list,
        ));
      case FailureResponse(:final failure):
        emitEvent(DisplayError.fromFailure(failure));
    }
  }

  Future<void> _onDeleteSession(String sessionId) async {
    final useCase = _deleteSessionUseCase;
    final list = state.sessions.where((s) => s.id != sessionId).toList();
    emit(state.copyWith(sessions: list));

    if (_currentSessionId == sessionId) {
      if (list.isNotEmpty) {
        await _onSelectSession(list.first.id);
      } else {
        await _onCreateNewSession(null);
      }
    }

    if (useCase != null) {
      await useCase(sessionId);
    }
  }

  Future<void> _onLoadHistory(String? sessionId) async {
    if (sessionId != null) _currentSessionId = sessionId;
    emit(state.copyWith(
      historyState: BaseState.loading(),
      isHistoryLoading: true,
      currentSessionId: _currentSessionId,
    ));

    final result = await _getChatHistoryUseCase(sessionId: _currentSessionId);
    switch (result) {
      case Success(:final data):
        final matching = state.sessions.where((s) => s.id == _currentSessionId).firstOrNull;
        emit(state.copyWith(
          historyState: BaseState.success(data),
          isHistoryLoading: false,
          messages: data,
          currentSessionTokens: matching?.totalTokens ?? state.currentSessionTokens,
        ));
      case FailureResponse(:final failure):
        emit(state.copyWith(
          historyState: BaseState.failure(failure),
          isHistoryLoading: false,
        ));
        emitEvent(DisplayError.fromFailure(failure));
    }
  }

  static String _formatDynamicTitle(String raw) {
    final collapsed = raw.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (collapsed.isEmpty) return 'New Chat';
    final capitalized = collapsed[0].toUpperCase() + collapsed.substring(1);
    return capitalized.length > 28 ? '${capitalized.substring(0, 28)}...' : capitalized;
  }

  Future<void> _onSendMessage(String message, String? sessionId) async {
    if (message.trim().isEmpty) return;
    if (sessionId != null) _currentSessionId = sessionId;

    if (state.isSessionLocked) {
      emitEvent(const DisplayError(
        'This conversation reached the 3000-token limit. Please start a new chat.',
      ));
      return;
    }

    final userMsg = ChatMessageEntity(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: 'user',
      content: message.trim(),
      timestamp: DateTime.now(),
    );

    final matching = state.sessions.where((s) => s.id == _currentSessionId).firstOrNull;
    var currentSessions = state.sessions;
    if (matching != null && (matching.title == 'New Chat' || matching.title.startsWith('Chat '))) {
      final dynamicTitle = _formatDynamicTitle(message);
      currentSessions = state.sessions.map((s) {
        if (s.id == _currentSessionId) return s.copyWith(title: dynamicTitle);
        return s;
      }).toList();
    }

    final updated = List<ChatMessageEntity>.from(state.messages)..add(userMsg);
    emit(state.copyWith(
      messages: updated,
      sessions: currentSessions,
      isTyping: true,
      sendMessageState: BaseState.loading(),
    ));

    if (_streamMessageUseCase != null) {
      final streamed = await _tryStreamFlow(message.trim());
      if (streamed) return;
    }

    final result = await _sendMessageUseCase(
      message: message.trim(),
      sessionId: _currentSessionId,
    );
    _handleSendMessageResult(result, message.trim());
  }

  Future<bool> _tryStreamFlow(String cleanMessage) async {
    try {
      var hasAddedAssistant = false;
      ChatMessageEntity? lastStreamed;

      await for (final chunk in _streamMessageUseCase!(
        message: cleanMessage,
        sessionId: _currentSessionId,
      )) {
        lastStreamed = chunk;
        if (!hasAddedAssistant) {
          hasAddedAssistant = true;
          _appendInitialAssistantChunk(chunk);
        } else {
          _updateStreamingChunk(chunk);
        }
      }

      if (lastStreamed != null) {
        _finalizeStream(lastStreamed, cleanMessage);
        return true;
      }
    } catch (_) {}
    return false;
  }

  void _appendInitialAssistantChunk(ChatMessageEntity chunk) {
    final list = List<ChatMessageEntity>.from(state.messages)
      ..add(chunk.copyWith(isStreaming: true));
    emit(state.copyWith(messages: list, isTyping: false));
  }

  void _updateStreamingChunk(ChatMessageEntity chunk) {
    final list = List<ChatMessageEntity>.from(state.messages);
    if (list.isNotEmpty) {
      list[list.length - 1] = chunk.copyWith(isStreaming: true);
      emit(state.copyWith(messages: list));
    }
  }

  void _finalizeStream(ChatMessageEntity finalMessage, String userPrompt) {
    final list = List<ChatMessageEntity>.from(state.messages);
    if (list.isNotEmpty) {
      list[list.length - 1] = finalMessage.copyWith(isStreaming: false);
    }
    final added = ((userPrompt.length + finalMessage.content.length) / 4).ceil();
    final updatedTokens = state.currentSessionTokens + added;
    emit(state.copyWith(
      messages: list,
      isTyping: false,
      sendMessageState: BaseState.success(finalMessage),
      currentSessionTokens: updatedTokens,
    ));
    _onLoadSessions();
  }

  void _handleSendMessageResult(
    ApiResults<ChatMessageEntity> result,
    String userPrompt,
  ) {
    switch (result) {
      case Success(:final data):
        final withAssistant = List<ChatMessageEntity>.from(state.messages)
          ..add(data);
        final added = ((userPrompt.length + data.content.length) / 4).ceil();
        final updatedTokens = state.currentSessionTokens + added;
        emit(state.copyWith(
          messages: withAssistant,
          isTyping: false,
          sendMessageState: BaseState.success(data),
          currentSessionTokens: updatedTokens,
        ));
        _onLoadSessions();
      case FailureResponse(:final failure):
        emit(state.copyWith(
          isTyping: false,
          sendMessageState: BaseState.failure(failure),
        ));
        emitEvent(DisplayError.fromFailure(failure));
    }
  }

  Future<void> _onClearHistory(String? sessionId) async {
    if (sessionId != null) _currentSessionId = sessionId;
    emit(state.copyWith(messages: const [], currentSessionTokens: 0));
    await _clearChatUseCase(sessionId: _currentSessionId);
    _onLoadSessions();
  }
}
