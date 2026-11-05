import 'package:super_fitness/features/ai_chat/core/constants/tool_names.dart';

abstract final class ToolDefinitions {
  static const Map<String, dynamic> searchExercisesTool = {
    'type': 'function',
    'function': {
      'name': ToolNames.searchExercises,
      'description': 'Search for fitness exercises by target muscle group or difficulty level',
      'parameters': {
        'type': 'object',
        'properties': {
          'query': {
            'type': 'string',
            'description': 'Search query or muscle group name',
          },
          'limit': {
            'type': 'integer',
            'description': 'Maximum number of results to return',
          },
        },
        'required': ['query'],
      },
    },
  };

  static const Map<String, dynamic> searchMealsTool = {
    'type': 'function',
    'function': {
      'name': ToolNames.searchMeals,
      'description': 'Search for healthy meals or recipes by dietary preference or calorie range',
      'parameters': {
        'type': 'object',
        'properties': {
          'query': {
            'type': 'string',
            'description': 'Search query for meals or ingredients',
          },
        },
        'required': ['query'],
      },
    },
  };

  static const List<Map<String, dynamic>> allTools = [
    searchExercisesTool,
    searchMealsTool,
  ];
}
