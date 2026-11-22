import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:super_fitness/core/const/app_constants.dart';
import 'package:super_fitness/core/const/endpoints.dart';
import 'package:super_fitness/features/meals/data/models/categories_response.dart';
import 'package:super_fitness/features/meals/data/models/meals_details_response.dart';
import 'package:super_fitness/features/meals/data/models/meals_response.dart';

part 'meals_api_client.g.dart';

@singleton
@RestApi(baseUrl: Endpoints.mealsBaseUrl)
abstract class MealsApiClient {
  @factoryMethod
  factory MealsApiClient(Dio dio) = _MealsApiClient;

  @GET(Endpoints.mealCategories)
  @Headers(<String, dynamic>{'Authorization': ''})
  Future<CategoriesResponse> getCategories();

  @GET(Endpoints.filterMealsByCategory)
  @Headers(<String, dynamic>{'Authorization': ''})
  Future<MealsResponse> getMealsByCategory(
    @Query(AppConstants.category) String category,
  );

  @GET(Endpoints.mealDetails)
  @Headers(<String, dynamic>{'Authorization': ''})
  Future<MealDetailsResponse> getMealDetails(
    @Query(AppConstants.mealId) String mealId,
  );
}