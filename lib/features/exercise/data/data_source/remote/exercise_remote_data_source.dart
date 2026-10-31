import 'package:super_fitness/features/exercise/data/model/exercise_models/difficulty_levels_response_model.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/exercise_response_model.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/muscles_response_model.dart';

abstract class ExerciseRemoteDataSource {
  Future<DifficultyLevelsResponseModel> getAllDifficultyLevels({
    required String language,
  });
  Future<ExerciseResponseModel> getExercisesByMuscleAndDifficulty({
    required String language,
    required String difficultyLevelId,
    required String primeMoverMuscleId,
  });
  Future<MusclesResponseModel> getMusclesByGroup({
    required String muscleGroupId,
  });
}
