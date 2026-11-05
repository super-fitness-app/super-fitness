import 'package:super_fitness/features/ai_chat/domain/entities/tool_result_entity.dart';

class ToolResultModel extends ToolResultEntity {
  const ToolResultModel({
    required super.toolCallId,
    required super.toolName,
    required super.result,
  });

  factory ToolResultModel.fromJson(Map<String, dynamic> json) {
    return ToolResultModel(
      toolCallId: json['tool_call_id'] as String? ?? '',
      toolName: json['tool_name'] as String? ?? '',
      result: json['result'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tool_call_id': toolCallId,
      'tool_name': toolName,
      'result': result,
    };
  }

  ToolResultEntity toEntity() {
    return ToolResultEntity(
      toolCallId: toolCallId,
      toolName: toolName,
      result: result,
    );
  }

  factory ToolResultModel.fromEntity(ToolResultEntity entity) {
    return ToolResultModel(
      toolCallId: entity.toolCallId,
      toolName: entity.toolName,
      result: entity.result,
    );
  }
}
