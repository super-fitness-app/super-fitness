import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:super_fitness/core/const/endpoints.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/difficulty_levels_response_model.dart';

part 'meals_api_client.g.dart';

@singleton
@RestApi()
abstract class MealsApiClient {
  @factoryMethod
  factory MealsApiClient(Dio dio) = _MealsApiClient;
  @GET(Endpoints.getAllDifficultyLevels)
  Future<DifficultyLevelsResponseModel> getAllDifficultyLevels({
    @Header('Accept-Language') required String language,
  });
}
