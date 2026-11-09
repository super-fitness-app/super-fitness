// import 'dart:convert';

// import 'package:injectable/injectable.dart';
// import 'package:super_fitness/features/ai_chat/core/constants/tool_names.dart';
// import 'package:super_fitness/features/ai_chat/data/tools/exercise/exercise_tools.dart';
// import 'package:super_fitness/features/ai_chat/data/tools/nutrition/nutrition_tools.dart';
// import 'package:super_fitness/features/ai_chat/domain/entities/tool_result_entity.dart';
// import 'package:super_fitness/features/ai_chat/domain/tools/fitness_tool_executor.dart';

// @LazySingleton(as: FitnessToolExecutor)
// class FitnessToolExecutorImpl implements FitnessToolExecutor {
//   final ExerciseTools _exerciseTools;
//   final NutritionTools _nutritionTools;

//   const FitnessToolExecutorImpl(this._exerciseTools, this._nutritionTools);

//   @override
//   Future<ToolResultEntity> executeTool(
//     String toolName,
//     Map<String, dynamic> arguments,
//   ) async {
//     late final Map<String, dynamic> toolResult;

//     try {
//       switch (toolName) {
//         case ToolNames.searchExercises:
//           toolResult = await _exerciseTools.searchExercises(arguments);
//           break;

//         case ToolNames.getExerciseDetails:
//           toolResult = await _exerciseTools.getExerciseDetails(arguments);
//           break;

//         case ToolNames.searchMeals:
//           toolResult = await _nutritionTools.searchMeals(arguments);
//           break;

//         case ToolNames.getMealDetails:
//           toolResult = await _nutritionTools.getMealDetails(arguments);
//           break;

//         default:
//           toolResult = {'success': false, 'error': 'Unknown tool: $toolName'};
//       }
//     } catch (e) {
//       toolResult = {'success': false, 'error': 'Tool execution failed.'};
//     }

//     return ToolResultEntity(
//       toolCallId: '',
//       toolName: toolName,
//       result: jsonEncode(toolResult),
//     );
//   }
// }
