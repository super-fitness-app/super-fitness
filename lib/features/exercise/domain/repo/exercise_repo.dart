import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/exercise_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';

abstract class ExerciseRepo {
  Future<ApiResults<List<DifficultyLevelEntity>>> getAllDifficultyLevels({
    required String language,
  });
  Future<ApiResults<List<ExerciseEntity>>> getExercisesByMuscleAndDifficulty({
    required String language,
    required String difficultyLevelId,
    required String primeMoverMuscleId,
  });
  Future<ApiResults<List<MuscleEntity>>> getMusclesByGroup(
    String muscleGroupId,
  );
}
