import 'package:super_fitness/features/ai_chat/data/models/tool_call_model.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';

class ChatMessageModel extends ChatMessageEntity {
  final List<ToolCallModel>? toolCalls;

  const ChatMessageModel({
    required super.id,
    required super.content,
    required super.role,
    required super.timestamp,
    this.toolCalls,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String? ?? '',
      content: json['content'] as String? ?? '',
      role: json['role'] as String? ?? '',
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'] as String) ?? DateTime.now()
          : DateTime.now(),
      toolCalls: (json['tool_calls'] as List<dynamic>?)
          ?.map((e) => ToolCallModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'role': role,
      'timestamp': timestamp.toIso8601String(),
      if (toolCalls != null)
        'tool_calls': toolCalls!.map((e) => e.toJson()).toList(),
    };
  }

  ChatMessageEntity toEntity() {
    return ChatMessageEntity(
      id: id,
      content: content,
      role: role,
      timestamp: timestamp,
    );
  }

  factory ChatMessageModel.fromEntity(ChatMessageEntity entity) {
    return ChatMessageModel(
      id: entity.id,
      content: entity.content,
      role: entity.role,
      timestamp: entity.timestamp,
    );
  }
}
