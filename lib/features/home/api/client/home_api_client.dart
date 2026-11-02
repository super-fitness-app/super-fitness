import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:super_fitness/core/const/endpoints.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/difficulty_levels_response_model.dart';

part 'home_api_client.g.dart';

@singleton
@RestApi()
abstract class HomeApiClient {
  @factoryMethod
  factory HomeApiClient(Dio dio) = _HomeApiClient;
  @GET(Endpoints.getAllDifficultyLevels)
  Future<DifficultyLevelsResponseModel> getAllDifficultyLevels({
    @Header('Accept-Language') required String language,
  });
}
