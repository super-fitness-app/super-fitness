import 'package:injectable/injectable.dart';

@lazySingleton
class ExerciseTools {
  const ExerciseTools();

  Future<String> searchExercises(Map<String, dynamic> arguments) async {
    return '[]';
  }

  Future<String> getExerciseDetails(Map<String, dynamic> arguments) async {
    return '{}';
  }
}
