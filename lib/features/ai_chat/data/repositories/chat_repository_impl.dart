import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/local/fitness_local_data_source.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';

import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/ingredient_entity.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/entities/meal_step_entity.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final FitnessLocalDataSource localDataSource;

  ChatRepositoryImpl(this.localDataSource);

  @override
  Future<List<MealEntity>> searchMeals({
    String? query,
    double? minCalories,
    double? maxCalories,
    double? minProtein,
  }) async {
    final models = await localDataSource.searchMeals(
      query: query,
      minCalories: minCalories,
      maxCalories: maxCalories,
      minProtein: minProtein,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<MealEntity?> getMealById(String id) async {
    final model = await localDataSource.getMealById(id);

    return model?.toEntity();
  }

  @override
  Future<List<IngredientEntity>> getMealIngredients(String mealId) async {
    final models = await localDataSource.getMealIngredients(mealId);

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<MealStepEntity>> getMealSteps(String mealId) async {
    final models = await localDataSource.getMealSteps(mealId);

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<List<ExerciseEntity>> searchExercises({
    String? query,
    String? muscleGroup,
    String? difficulty,
    String? equipment,
  }) async {
    final models = await localDataSource.searchExercises(
      query: query,
      muscleGroup: muscleGroup,
      difficulty: difficulty,
      equipment: equipment,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ExerciseEntity?> getExerciseById(String id) async {
    final model = await localDataSource.getExerciseById(id);

    return model?.toEntity();
  }
}
