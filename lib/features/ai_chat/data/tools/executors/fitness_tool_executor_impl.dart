import 'dart:convert';
import 'package:flutter/foundation.dart';
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

  const FitnessToolExecutorImpl(this._exerciseTools, this._nutritionTools);

  @override
  Future<ToolResultEntity> executeTool(
    String toolName,
    Map<String, dynamic> arguments,
  ) async {
    Map<String, dynamic> toolResult;

    try {
      toolResult = await switch (toolName) {
        ToolNames.searchExercises => _exerciseTools.searchExercises(arguments),
        ToolNames.getExerciseDetails => _exerciseTools.getExerciseDetails(arguments),
        ToolNames.searchMeals => _nutritionTools.searchMeals(arguments),
        ToolNames.getMealDetails => _nutritionTools.getMealDetails(arguments),
        _ => Future.value({'success': false, 'error': 'Unknown tool: $toolName'}),
      };
    } catch (e) {
      debugPrint('[AiChat] Tool $toolName execution error: $e');
      toolResult = {'success': false, 'error': 'Tool execution failed.'};
    }

    return ToolResultEntity(
      toolCallId: '',
      toolName: toolName,
      result: jsonEncode(toolResult),
    );
  }
}
