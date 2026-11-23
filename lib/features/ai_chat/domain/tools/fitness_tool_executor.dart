import 'package:super_fitness/features/ai_chat/domain/entities/tool_result_entity.dart';

abstract interface class FitnessToolExecutor {
  Future<ToolResultEntity> executeTool(
    String toolName,
    Map<String, dynamic> arguments,
  );
}
