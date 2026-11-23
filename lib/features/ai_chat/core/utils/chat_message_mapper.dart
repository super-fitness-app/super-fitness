import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/ingredient_entity.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/entities/meal_step_entity.dart';

class ChatMessageMapper {
  const ChatMessageMapper();

  Map<String, dynamic> mealToJson(MealEntity meal) {
    return {
      'id': meal.id,
      'name': meal.name,
      'name_ar': meal.nameAr,
      'category': meal.category,
      'area': meal.area,
      'meal_type': meal.mealType,
      'calories': meal.calories,
      'protein': meal.protein,
      'carbs': meal.carbs,
      'fat': meal.fat,
      'nutrition_is_estimate': meal.nutritionIsEstimate,
      'nutrition_confidence': meal.nutritionConfidence,
      'vegetarian': meal.vegetarian,
      'vegan': meal.vegan,
      'contains_gluten': meal.containsGluten,
      'contains_nuts': meal.containsNuts,
      'ingredient_count': meal.ingredientCount,
      'thumbnail': meal.thumbnail,
      'youtube': meal.youtube,
      'tags': meal.tags,
      'popularity': meal.popularity,
    };
  }

  Map<String, dynamic> ingredientToJson(IngredientEntity ingredient) {
    return {
      'id': ingredient.id,
      'name': ingredient.name,
      'name_ar': ingredient.nameAr,
      'image': ingredient.image,
      'calories_per_100g': ingredient.caloriesPer100g,
      'protein_per_100g': ingredient.proteinPer100g,
      'carbs_per_100g': ingredient.carbsPer100g,
      'fat_per_100g': ingredient.fatPer100g,
      'meal_id': ingredient.mealId,
      'position': ingredient.position,
      'quantity': ingredient.quantity,
      'unit': ingredient.unit,
      'measure_raw': ingredient.measureRaw,
    };
  }

  Map<String, dynamic> mealStepToJson(MealStepEntity step) {
    return {
      'meal_id': step.mealId,
      'position': step.position,
      'text': step.text,
    };
  }

  Map<String, dynamic> exerciseToJson(ExerciseEntity exercise) {
    return {
      'id': exercise.id,
      'name': exercise.name,
      'name_ar': exercise.nameAr,
      'muscle_group': exercise.muscleGroup,
      'muscle_group_ar': exercise.muscleGroupAr,
      'prime_mover': exercise.primeMover,
      'prime_mover_ar': exercise.primeMoverAr,
      'difficulty': exercise.difficulty,
      'difficulty_rank': exercise.difficultyRank,
      'equipment': exercise.equipment,
      'body_region': exercise.bodyRegion,
      'mechanics': exercise.mechanics,
      'posture': exercise.posture,
      'laterality': exercise.laterality,
      'force_type': exercise.forceType,
      'demo_url': exercise.demoUrl,
      'explain_url': exercise.explainUrl,
      'popularity': exercise.popularity,
      'movement_patterns': exercise.movementPatterns,
    };
  }

  List<Map<String, dynamic>> mealsToJson(List<MealEntity> meals) {
    return meals.map(mealToJson).toList();
  }

  List<Map<String, dynamic>> exercisesToJson(List<ExerciseEntity> exercises) {
    return exercises.map(exerciseToJson).toList();
  }

  List<Map<String, dynamic>> ingredientsToJson(
    List<IngredientEntity> ingredients,
  ) {
    return ingredients.map(ingredientToJson).toList();
  }

  List<Map<String, dynamic>> stepsToJson(List<MealStepEntity> steps) {
    return steps.map(mealStepToJson).toList();
  }
}
