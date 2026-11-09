import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/ai_chat/data/database/fitness_database_manager.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/contract/fitness_local_data_source.dart';
import 'package:super_fitness/features/ai_chat/data/models/exercise_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/ingredient_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/meal_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/meal_step_model.dart';

@LazySingleton(as: FitnessLocalDataSource)
class FitnessLocalDataSourceImpl implements FitnessLocalDataSource {
  final FitnessDatabaseManager _databaseManager;

  FitnessLocalDataSourceImpl(this._databaseManager);

  // ============================================================
  // NUTRITION
  // ============================================================

  @override
  Future<List<MealModel>> searchMeals({
    String? query,
    double? minCalories,
    double? maxCalories,
    double? minProtein,
  }) async {
    final db = await _databaseManager.getDatabase(FitnessDatabase.meals);

    final conditions = <String>[];
    final arguments = <Object?>[];

    if (query != null && query.trim().isNotEmpty) {
      conditions.add('''
        (
          name LIKE ?
          OR name_ar LIKE ?
          OR category LIKE ?
          OR area LIKE ?
          OR tags LIKE ?
        )
      ''');

      final searchQuery = '%${query.trim()}%';

      arguments.addAll(List.filled(5, searchQuery));
    }

    if (minCalories != null) {
      conditions.add('kcal >= ?');
      arguments.add(minCalories);
    }

    if (maxCalories != null) {
      conditions.add('kcal <= ?');
      arguments.add(maxCalories);
    }

    if (minProtein != null) {
      conditions.add('protein_g >= ?');
      arguments.add(minProtein);
    }

    final whereClause = conditions.isEmpty ? null : conditions.join(' AND ');

    final result = await db.query(
      'meal_card',
      where: whereClause,
      whereArgs: arguments,
      orderBy: 'popularity DESC, name ASC',
      limit: 50,
    );

    return result.map((row) => MealModel.fromJson(row)).toList();
  }

  @override
  Future<MealModel?> getMealById(String id) async {
    final db = await _databaseManager.getDatabase(FitnessDatabase.meals);

    final result = await db.query(
      'meal_card',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return MealModel.fromJson(result.first);
  }

  @override
  Future<List<IngredientModel>> getMealIngredients(String mealId) async {
    final db = await _databaseManager.getDatabase(FitnessDatabase.meals);

    final result = await db.rawQuery(
      '''
      SELECT
        i.id AS id,
        i.name AS name,
        i.name_ar AS name_ar,
        i.image AS image,
        i.kcal_100g AS kcal_100g,
        i.protein_100g AS protein_100g,
        i.carbs_100g AS carbs_100g,
        i.fat_100g AS fat_100g,
        mi.meal_id AS meal_id,
        mi.position AS position,
        mi.qty AS qty,
        mi.unit AS unit,
        mi.measure_raw AS measure_raw
      FROM meal_ingredient mi
      INNER JOIN ingredient i
        ON i.id = mi.ingredient_id
      WHERE mi.meal_id = ?
      ORDER BY mi.position ASC
      ''',
      [mealId],
    );

    return result.map((row) => IngredientModel.fromJson(row)).toList();
  }

  @override
  Future<List<MealStepModel>> getMealSteps(String mealId) async {
    final db = await _databaseManager.getDatabase(FitnessDatabase.meals);

    final result = await db.query(
      'meal_step',
      where: 'meal_id = ?',
      whereArgs: [mealId],
      orderBy: 'position ASC',
    );

    return result.map((row) => MealStepModel.fromJson(row)).toList();
  }

  @override
  Future<Map<String, dynamic>> getMealNutrition({
    required String mealName,
    String? goal,
  }) async {
    final meals = await searchMeals(query: mealName);

    if (meals.isEmpty) {
      return {
        'card_type': 'meal',
        'card_title': mealName,
        'card_subtitle': 'Meal not found',
        'card_details': {},
        'card_items': [],
      };
    }

    final meal = meals.first;

    return {
      'card_type': 'meal',
      'card_title': meal.name,
      'card_subtitle':
          meal.category ?? meal.mealType ?? 'Nutrition information',
      'badge': goal,
      'card_details': {
        if (meal.calories != null) 'calories': '${meal.calories} kcal',
        if (meal.protein != null) 'protein': '${meal.protein} g',
        if (meal.carbs != null) 'carbs': '${meal.carbs} g',
        if (meal.fat != null) 'fat': '${meal.fat} g',
        if (meal.nutritionIsEstimate != null)
          'estimated': meal.nutritionIsEstimate! ? 'Yes' : 'No',
      },
      'card_items': [],
    };
  }
  // ============================================================
  // EXERCISES
  // ============================================================

  @override
  Future<List<ExerciseModel>> searchExercises({
    String? query,
    String? muscleGroup,
    String? difficulty,
    String? equipment,
  }) async {
    final db = await _databaseManager.getDatabase(FitnessDatabase.exercises);

    final conditions = <String>[];
    final arguments = <Object?>[];

    if (query != null && query.trim().isNotEmpty) {
      conditions.add('''
        (
          name LIKE ?
          OR name_ar LIKE ?
          OR muscle_group LIKE ?
          OR prime_mover LIKE ?
          OR equipment LIKE ?
          OR movement_patterns LIKE ?
        )
      ''');

      final searchQuery = '%${query.trim()}%';

      arguments.addAll(List.filled(6, searchQuery));
    }

    if (muscleGroup != null && muscleGroup.trim().isNotEmpty) {
      conditions.add('muscle_group LIKE ?');
      arguments.add('%${muscleGroup.trim()}%');
    }

    if (difficulty != null && difficulty.trim().isNotEmpty) {
      conditions.add('difficulty LIKE ?');
      arguments.add('%${difficulty.trim()}%');
    }

    if (equipment != null && equipment.trim().isNotEmpty) {
      conditions.add('equipment LIKE ?');
      arguments.add('%${equipment.trim()}%');
    }

    final whereClause = conditions.isEmpty ? null : conditions.join(' AND ');

    final result = await db.query(
      'exercise_card',
      where: whereClause,
      whereArgs: arguments,
      orderBy: 'popularity DESC, name ASC',
      limit: 100,
    );

    return result.map((row) => ExerciseModel.fromJson(row)).toList();
  }

  @override
  Future<Map<String, dynamic>> getExerciseDetails({
    required String exerciseName,
    String? targetMuscle,
  }) async {
    final exercises = await searchExercises(query: exerciseName);

    if (exercises.isEmpty) {
      return {
        'card_type': 'exercise',
        'card_title': exerciseName,
        'card_subtitle': 'Exercise not found',
        'card_details': {},
        'card_items': [],
      };
    }

    final exercise = exercises.first;

    return {
      'card_type': 'exercise',
      'card_title': exercise.name,
      'card_subtitle': exercise.muscleGroup ?? 'Exercise details',
      'badge': targetMuscle ?? exercise.primeMover ?? exercise.muscleGroup,
      'card_details': {
        if (exercise.equipment != null) 'equipment': exercise.equipment!,
        if (exercise.difficulty != null) 'difficulty': exercise.difficulty!,
        if (exercise.bodyRegion != null) 'body_region': exercise.bodyRegion!,
        if (exercise.mechanics != null) 'mechanics': exercise.mechanics!,
        if (exercise.forceType != null) 'force_type': exercise.forceType!,
      },
      'card_items': [
        if (exercise.primeMover != null)
          'Primary muscle: ${exercise.primeMover}',
        if (exercise.movementPatterns != null)
          'Movement pattern: ${exercise.movementPatterns}',
        if (exercise.posture != null) 'Posture: ${exercise.posture}',
        if (exercise.laterality != null) 'Laterality: ${exercise.laterality}',
      ],
    };
  }

  @override
  Future<ExerciseModel?> getExerciseById(String id) async {
    final db = await _databaseManager.getDatabase(FitnessDatabase.exercises);

    final result = await db.query(
      'exercise_card',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    if (result.isEmpty) return null;

    return ExerciseModel.fromJson(result.first);
  }
}
