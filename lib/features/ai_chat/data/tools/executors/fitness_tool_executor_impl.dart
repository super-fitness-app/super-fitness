import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/ai_chat/core/constants/tool_names.dart';
import 'package:super_fitness/features/ai_chat/data/tools/exercise/exercise_tools.dart';
import 'package:super_fitness/features/ai_chat/data/tools/nutrition/nutrition_tools.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/tool_result_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/tools/fitness_tool_executor.dart';

@LazySingleton(as: FitnessToolExecutor)
class FitnessToolExecutorImpl implements FitnessToolExecutor {
  final ExerciseTools _exerciseTools;
  final NutritionTools _nutritionTools;

  const FitnessToolExecutorImpl(
    this._exerciseTools,
    this._nutritionTools,
  );

  @override
  Future<ToolResultEntity> executeTool(
    String toolName,
    Map<String, dynamic> arguments,
  ) async {
    final String result;
    switch (toolName) {
      case ToolNames.searchExercises:
        result = await _exerciseTools.searchExercises(arguments);
      case ToolNames.getExerciseDetails:
        result = await _exerciseTools.getExerciseDetails(arguments);
      case ToolNames.searchMeals:
        result = await _nutritionTools.searchMeals(arguments);
      case ToolNames.getMealDetails:
        result = await _nutritionTools.getMealDetails(arguments);
      default:
        result = 'Unknown tool: $toolName';
    }

    return ToolResultEntity(
      toolCallId: '',
      toolName: toolName,
      result: result,
    );
  }
}
