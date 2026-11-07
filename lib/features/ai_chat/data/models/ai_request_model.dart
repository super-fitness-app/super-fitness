import 'package:super_fitness/features/ai_chat/data/models/chat_message_model.dart';

class AiRequestModel {
  final String model;
  final List<ChatMessageModel> messages;
  final bool stream;
  final List<Map<String, dynamic>>? tools;
  final Map<String, dynamic>? options;

  const AiRequestModel({
    required this.model,
    required this.messages,
    this.stream = false,
    this.tools,
    this.options,
  });

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      'messages': messages.map((m) => m.toJson()).toList(),
      'stream': stream,
      if (tools != null) 'tools': tools,
      if (options != null) 'options': options,
    };
  }

  factory AiRequestModel.fromJson(Map<String, dynamic> json) {
    return AiRequestModel(
      model: json['model'] as String? ?? '',
      messages:
          (json['messages'] as List<dynamic>?)
              ?.map((e) => ChatMessageModel.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      stream: json['stream'] as bool? ?? false,
      tools: (json['tools'] as List<dynamic>?)
          ?.map((e) => e as Map<String, dynamic>)
          .toList(),
      options: json['options'] as Map<String, dynamic>?,
    );
  }
}
