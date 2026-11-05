import 'package:super_fitness/features/ai_chat/data/models/chat_message_model.dart';

class AiResponseModel {
  final String model;
  final DateTime? createdAt;
  final ChatMessageModel? message;
  final bool done;
  final int? totalDuration;
  final int? promptEvalCount;
  final int? evalCount;

  const AiResponseModel({
    required this.model,
    this.createdAt,
    this.message,
    this.done = false,
    this.totalDuration,
    this.promptEvalCount,
    this.evalCount,
  });

  factory AiResponseModel.fromJson(Map<String, dynamic> json) {
    return AiResponseModel(
      model: json['model'] as String? ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'] as String)
          : null,
      message: json['message'] != null
          ? ChatMessageModel.fromJson(json['message'] as Map<String, dynamic>)
          : null,
      done: json['done'] as bool? ?? false,
      totalDuration: json['total_duration'] as int?,
      promptEvalCount: json['prompt_eval_count'] as int?,
      evalCount: json['eval_count'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'model': model,
      if (createdAt != null) 'created_at': createdAt!.toIso8601String(),
      if (message != null) 'message': message!.toJson(),
      'done': done,
      if (totalDuration != null) 'total_duration': totalDuration,
      if (promptEvalCount != null) 'prompt_eval_count': promptEvalCount,
      if (evalCount != null) 'eval_count': evalCount,
    };
  }
}
