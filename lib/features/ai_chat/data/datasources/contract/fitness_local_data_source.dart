import 'package:super_fitness/features/ai_chat/data/models/exercise_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/ingredient_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/meal_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/meal_step_model.dart';

abstract interface class FitnessLocalDataSource {
  // Nutrition
  Future<List<MealModel>> searchMeals({
    String? query,
    double? minCalories,
    double? maxCalories,
    double? minProtein,
  });

  Future<MealModel?> getMealById(String id);

  Future<List<IngredientModel>> getMealIngredients(String mealId);

  Future<List<MealStepModel>> getMealSteps(String mealId);

  Future<Map<String, dynamic>> getMealNutrition({
    required String mealName,
    String? goal,
  });

  // Exercises
  Future<List<ExerciseModel>> searchExercises({
    String? query,
    String? muscleGroup,
    String? difficulty,
    String? equipment,
  });

  Future<ExerciseModel?> getExerciseById(String id);

  Future<Map<String, dynamic>> getExerciseDetails({
    required String exerciseName,
    String? targetMuscle,
  });
}
