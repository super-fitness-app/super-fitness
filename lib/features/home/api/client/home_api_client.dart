import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:super_fitness/core/const/endpoints.dart';
import 'package:super_fitness/features/home/data/models/meal_categories_response_dto.dart';
import 'package:super_fitness/features/home/data/models/muscle_groups_response_dto.dart';
import 'package:super_fitness/features/home/data/models/muscles_by_group_response_dto.dart';
import 'package:super_fitness/features/home/data/models/random_muscles_response_dto.dart';

part 'home_api_client.g.dart';

@singleton
@RestApi()
abstract class HomeApiClient {
  @factoryMethod
  factory HomeApiClient(Dio dio) = _HomeApiClient;

  @GET(Endpoints.randomMuscles)
  Future<RandomMusclesResponseDto> getRandomMuscles();

  @GET(Endpoints.muscles)
  Future<MuscleGroupsResponseDto> getMuscleGroups();

  @GET(Endpoints.musclesGroup)
  Future<MusclesByGroupResponseDto> getMusclesByMuscleGroupId(
    @Path('id') String id,
  );

  @GET(Endpoints.mealCategoriesUrl)
  Future<MealCategoriesResponseDto> getMealCategories();
}
