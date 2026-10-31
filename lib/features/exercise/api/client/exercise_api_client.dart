import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:super_fitness/core/const/endpoints.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/difficulty_levels_response_model.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/exercise_response_model.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/muscles_response_model.dart';

part 'exercise_api_client.g.dart';

@singleton
@RestApi()
abstract class ExerciseApiClient {
  @factoryMethod
  factory ExerciseApiClient(Dio dio) = _ExerciseApiClient;

  @GET('exercises')
  Future<ExerciseResponseModel> getAllExercises({
    @Header('Accept-Language') required String language,
    @Query('page') int page = 1,
  });
  @GET(Endpoints.getAllDifficultyLevels)
  Future<DifficultyLevelsResponseModel> getAllDifficultyLevels({
    @Header('Accept-Language') required String language,
  });
  @GET(Endpoints.musclesByGroup)
  Future<MusclesResponseModel> getMusclesByGroup(
    @Query('muscleGroupId') String muscleGroupId,
  );
  @GET(Endpoints.exercisesByMuscleDifficulty)
  Future<ExerciseResponseModel> getExercisesByMuscleAndDifficulty(
    @Header('Accept-Language') String language,
    @Query('difficultyLevelId') String difficultyLevelId,
    @Query('primeMoverMuscleId') String primeMoverMuscleId,
  );
}
