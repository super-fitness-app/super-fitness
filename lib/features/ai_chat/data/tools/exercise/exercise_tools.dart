import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/local/fitness_local_data_source.dart';

@lazySingleton
class ExerciseTools {
  final FitnessLocalDataSource _dataSource;

  ExerciseTools(this._dataSource);

  Future<Map<String, dynamic>> searchExercises(
    Map<String, dynamic> arguments,
  ) async {
    try {
      final query = _getString(arguments, 'query');

      final exercises = await _dataSource.searchExercises(query: query);

      return {
        'success': true,
        'data': {
          'count': exercises.length,
          'exercises': exercises.map((e) => e.toJson()).toList(),
        },
      };
    } catch (e) {
      return {'success': false, 'error': 'Failed to search exercises: $e'};
    }
  }

  Future<Map<String, dynamic>> getExerciseDetails(
    Map<String, dynamic> arguments,
  ) async {
    try {
      final exerciseId = _getString(arguments, 'exercise_id');

      if (exerciseId == null) {
        return {'success': false, 'error': 'Exercise ID is required.'};
      }

      final exercise = await _dataSource.getExerciseById(exerciseId);

      if (exercise == null) {
        return {'success': false, 'error': 'Exercise not found.'};
      }

      return {
        'success': true,
        'data': {'exercise': exercise.toJson()},
      };
    } catch (e) {
      return {'success': false, 'error': 'Failed to get exercise details: $e'};
    }
  }

  String? _getString(Map<String, dynamic> arguments, String key) {
    final value = arguments[key];

    if (value is! String) return null;

    final trimmed = value.trim();

    return trimmed.isEmpty ? null : trimmed;
  }
}
