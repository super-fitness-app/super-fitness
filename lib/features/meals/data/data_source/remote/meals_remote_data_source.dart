import 'package:super_fitness/features/meals/data/models/categories_response.dart';
import 'package:super_fitness/features/meals/data/models/meals_details_response.dart';
import 'package:super_fitness/features/meals/data/models/meals_response.dart';

abstract class MealsRemoteDataSource {
  Future<CategoriesResponse> getCategories();

  Future<MealsResponse> getMealsByCategory(String category);

  Future<MealDetailsResponse> getMealDetails(String mealId);
}
