import 'package:super_fitness/features/ai_chat/core/constants/tool_names.dart';

abstract final class ToolDefinitions {
  static const List<Map<String, dynamic>> tools = [
    {
      'type': 'function',
      'function': {
        'name': ToolNames.getExerciseDetails,
        'description':
            'Look up mechanics, muscle targets, sets, reps, and cues for an exercise.',
        'parameters': {
          'type': 'object',
          'properties': {
            ToolNames.paramExerciseName: {
              'type': 'string',
              'description':
                  'The name of the exercise (e.g. bench press, squat, deadlift).',
            },
            ToolNames.paramTargetMuscle: {
              'type': 'string',
              'description':
                  'Optional specific muscle targeted (e.g. chest, quads, back).',
            },
          },
          'required': [ToolNames.paramExerciseName],
        },
      },
    },
    {
      'type': 'function',
      'function': {
        'name': ToolNames.getMealNutrition,
        'description':
            'Look up calorie breakdowns, macronutrients, and recipe details for healthy meals.',
        'parameters': {
          'type': 'object',
          'properties': {
            ToolNames.paramMealName: {
              'type': 'string',
              'description':
                  'The name of the meal or food item (e.g. chicken breast, oatmeal).',
            },
            ToolNames.paramGoal: {
              'type': 'string',
              'description':
                  'Optional dietary goal (e.g. bulk, cut, maintenance).',
            },
          },
          'required': [ToolNames.paramMealName],
        },
      },
    },
  ];
}
