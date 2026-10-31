import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/exercise/api/client/exercise_api_client.dart';
import 'package:super_fitness/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/difficulty_levels_response_model.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/exercise_response_model.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/muscles_response_model.dart';

@Injectable(as: ExerciseRemoteDataSource)
class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final ExerciseApiClient _exerciseApiClient;

  ExerciseRemoteDataSourceImpl(this._exerciseApiClient);

  @override
  Future<DifficultyLevelsResponseModel> getAllDifficultyLevels({
    required String language,
  }) async {
    return await _exerciseApiClient.getAllDifficultyLevels(language: language);
  }

  @override
  Future<MusclesResponseModel> getMusclesByGroup({
    required String muscleGroupId,
  }) async {
    return await _exerciseApiClient.getMusclesByGroup(muscleGroupId);
  }

  @override
  Future<ExerciseResponseModel> getExercisesByMuscleAndDifficulty({
    required String language,
    required String difficultyLevelId,
    required String primeMoverMuscleId,
  }) async {
    return await _exerciseApiClient.getExercisesByMuscleAndDifficulty(
      language,
      difficultyLevelId,
      primeMoverMuscleId,
    );
  }
}
