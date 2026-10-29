import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/meals/domain/entities/category_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';

abstract interface class MealsRepo {
  Future<ApiResults<List<CategoryEntity>>> getCategories();

  Future<ApiResults<List<MealEntity>>> getMealsByCategory(
    String category,
  );

  Future<ApiResults<MealDetailsEntity>> getMealDetails(String mealId);
}