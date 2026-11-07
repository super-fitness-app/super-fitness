import 'package:super_fitness/features/ai_chat/domain/entities/exercise_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/ingredient_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/meal_step_entity.dart';

abstract interface class ChatRepository {
  Future<List<MealEntity>> searchMeals({
    String? query,
    double? minCalories,
    double? maxCalories,
    double? minProtein,
  });

  Future<MealEntity?> getMealById(String id);

  Future<List<IngredientEntity>> getMealIngredients(String mealId);

  Future<List<MealStepEntity>> getMealSteps(String mealId);

  Future<List<ExerciseEntity>> searchExercises({
    String? query,
    String? muscleGroup,
    String? difficulty,
    String? equipment,
  });

  Future<ExerciseEntity?> getExerciseById(String id);
}
