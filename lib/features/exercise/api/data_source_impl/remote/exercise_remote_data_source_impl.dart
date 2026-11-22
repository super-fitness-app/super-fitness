import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/exercise/api/client/exercise_api_client.dart';
import 'package:super_fitness/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/difficulty_levels_response_model.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/exercise_response_model.dart';
import 'package:super_fitness/features/exercise/data/models/muscle_groups_response_model.dart';
import 'package:super_fitness/features/exercise/data/models/muscles_by_group_response_model.dart';

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

  @override
  Future<MuscleGroupsResponseModel> getMuscleGroups() async {
    return await _exerciseApiClient.getMuscleGroups();
  }

  @override
  Future<MusclesByGroupResponseModel> getMusclesByGroup(String groupId) async {
    return await _exerciseApiClient.getMusclesByGroup(groupId);
  }
}
