import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/meals/data/models/categories_response.dart';
import 'package:super_fitness/features/meals/data/models/meals_response.dart';
import 'package:super_fitness/features/meals/data/models/meals_details_response.dart';
import 'package:super_fitness/features/meals/domain/entities/category_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';

@lazySingleton
class MealsMapper {
  List<CategoryEntity> mapCategoryListToEntityList(
    List<Category> categories,
  ) {
    return categories.map((category) {
      return CategoryEntity(
        id: category.id,
        name: category.name,
        imageUrl: category.imageUrl,
        description: category.description,
      );
    }).toList();
  }

  List<MealEntity> mapMealListToEntityList(List<Meal> meals) {
    return meals.map((meal) {
      return MealEntity(
        id: meal.id,
        name: meal.name,
        imageUrl: meal.imageUrl,
      );
    }).toList();
  }

  MealDetailsEntity mapMealDetailsToEntity(MealDetails meal) {
    return MealDetailsEntity(
      id: meal.id,
      name: meal.name,
      category: meal.category,
      area: meal.area,
      instructions: meal.instructions,
      imageUrl: meal.imageUrl,
      youtubeUrl: meal.youtubeUrl,
      sourceUrl: meal.sourceUrl,
      ingredients: meal.ingredients.map((ingredient) {
        return MealIngredientEntity(
          name: ingredient.name!,
          measure: ingredient.measure,
        );
      }).toList(),
    );
  }
}