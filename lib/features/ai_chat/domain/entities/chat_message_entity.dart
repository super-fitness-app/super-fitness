import 'package:equatable/equatable.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/fitness_card_entity.dart';

class ChatMessageEntity extends Equatable {
  final String id;
  final String role;
  final String content;
  final DateTime timestamp;
  final FitnessCardEntity? fitnessCard;
  final bool isToolResponse;
  final bool isStreaming;
  final String? thought;
  final String? thinkingStatus;

  const ChatMessageEntity({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.fitnessCard,
    this.isToolResponse = false,
    this.isStreaming = false,
    this.thought,
    this.thinkingStatus,
  });

  bool get isUser => role == 'user';
  bool get isAssistant => role == 'assistant';
  bool get isThinking =>
      isStreaming && content.isEmpty && (thought != null || thinkingStatus != null);

  ChatMessageEntity copyWith({
    String? id,
    String? role,
    String? content,
    DateTime? timestamp,
    FitnessCardEntity? fitnessCard,
    bool? isToolResponse,
    bool? isStreaming,
    String? thought,
    String? thinkingStatus,
  }) {
    return ChatMessageEntity(
      id: id ?? this.id,
      role: role ?? this.role,
      content: content ?? this.content,
      timestamp: timestamp ?? this.timestamp,
      fitnessCard: fitnessCard ?? this.fitnessCard,
      isToolResponse: isToolResponse ?? this.isToolResponse,
      isStreaming: isStreaming ?? this.isStreaming,
      thought: thought ?? this.thought,
      thinkingStatus: thinkingStatus ?? this.thinkingStatus,
    );
  }

  @override
  List<Object?> get props => [
    id,
    role,
    content,
    timestamp,
    fitnessCard,
    isToolResponse,
    isStreaming,
    thought,
    thinkingStatus,
  ];
}
