import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:super_fitness/core/const/api_params.dart';
import 'package:super_fitness/features/ai_chat/data/models/structured_fitness_card_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/tool_call_model.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';

class ChatMessageModel extends Equatable {
  final String id;
  final String role;
  final String content;
  final DateTime timestamp;
  final StructuredFitnessCardModel? fitnessCard;
  final List<ToolCallModel> toolCalls;
  final bool isToolResponse;
  final String? thought;
  final String? thinkingStatus;

  const ChatMessageModel({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.fitnessCard,
    this.toolCalls = const [],
    this.isToolResponse = false,
    this.thought,
    this.thinkingStatus,
  });

  ChatMessageModel copyWith({
    String? id,
    String? role,
    String? content,
    DateTime? timestamp,
    StructuredFitnessCardModel? fitnessCard,
    List<ToolCallModel>? toolCalls,
    bool? isToolResponse,
    String? thought,
    String? thinkingStatus,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      fitnessCard: fitnessCard ?? this.fitnessCard,
      toolCalls: toolCalls ?? this.toolCalls,
      isToolResponse: isToolResponse ?? this.isToolResponse,
      thought: thought ?? this.thought,
      thinkingStatus: thinkingStatus ?? this.thinkingStatus,
    );
  }

  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      role: entity.role,
      content: entity.content,
      timestamp: entity.timestamp,
      fitnessCard: entity.fitnessCard != null
          ? StructuredFitnessCardModel(
              cardType: entity.fitnessCard!.cardType.name,
              title: entity.fitnessCard!.title,
              subtitle: entity.fitnessCard!.subtitle,
              badge: entity.fitnessCard!.badge,
              metrics: entity.fitnessCard!.metrics,
              bulletPoints: entity.fitnessCard!.bulletPoints,
            )
          : null,
      isToolResponse: entity.isToolResponse,
      thought: entity.thought,
      thinkingStatus: entity.thinkingStatus,
    );
  }

  factory ChatMessageModel.fromOllamaJson(Map<String, dynamic> json) {
    final rawTools = json[ApiParams.toolCalls];
    final List<ToolCallModel> parsedToolCalls = [];
    if (rawTools is List) {
      for (final t in rawTools) {
        if (t is Map<String, dynamic>) {
          parsedToolCalls.add(ToolCallModel.fromJson(t));
        }
      }
    }

    return ChatMessageModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      role: (json[ApiParams.role] as String?) ?? 'assistant',
      content: (json[ApiParams.content] as String?) ?? '',
      timestamp: DateTime.now(),
      toolCalls: parsedToolCalls,
      isToolResponse: json[ApiParams.role] == 'tool',
    );
  }

  factory ChatMessageModel.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final data = doc.data() ?? {};
    final rawTimestamp = data[ApiParams.timestamp];
    DateTime parsedTime = DateTime.now();

    if (rawTimestamp is Timestamp) {
      parsedTime = rawTimestamp.toDate();
    } else if (rawTimestamp is String) {
      parsedTime = DateTime.tryParse(rawTimestamp) ?? DateTime.now();
    } else if (rawTimestamp is int) {
      parsedTime = DateTime.fromMillisecondsSinceEpoch(rawTimestamp);
    }

    StructuredFitnessCardModel? card;
    final meta = data[ApiParams.metadata];
    if (meta is Map<String, dynamic> && meta[ApiParams.fitnessCard] != null) {
      card = StructuredFitnessCardModel.fromJson(
        Map<String, dynamic>.from(meta[ApiParams.fitnessCard] as Map),
      );
    }

    return ChatMessageModel(
      id: doc.id,
      role: (data[ApiParams.role] as String?) ?? 'user',
      content: (data[ApiParams.content] as String?) ?? '',
      timestamp: parsedTime,
      fitnessCard: card,
      isToolResponse: data[ApiParams.role] == 'tool',
    );
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      ApiParams.role: role,
      ApiParams.content: content,
      ApiParams.timestamp: FieldValue.serverTimestamp(),
      if (fitnessCard != null)
        ApiParams.metadata: {ApiParams.fitnessCard: fitnessCard!.toJson()},
    };
  }

  Map<String, dynamic> toOllamaJson() {
    return {ApiParams.role: role, ApiParams.content: content};
  }

  ChatMessageEntity toEntity({bool isStreaming = false}) => ChatMessageEntity(
    id: id,
    role: role,
    content: content,
    timestamp: timestamp,
    fitnessCard: fitnessCard?.toEntity(),
    isToolResponse: isToolResponse,
    isStreaming: isStreaming,
    thought: thought,
    thinkingStatus: thinkingStatus,
  );

  @override
  List<Object?> get props => [
    id,
    role,
    content,
    timestamp,
    fitnessCard,
    toolCalls,
    isToolResponse,
    thought,
    thinkingStatus,
  ];
}
