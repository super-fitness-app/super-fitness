import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/contract/fitness_local_data_source.dart';

@lazySingleton
class NutritionTools {
  final FitnessLocalDataSource _dataSource;

  NutritionTools(this._dataSource);

  Future<Map<String, dynamic>> searchMeals(
    Map<String, dynamic> arguments,
  ) async {
    try {
      final query = _getString(arguments, 'query');
      final minCalories = _getDouble(arguments, 'min_calories');
      final maxCalories = _getDouble(arguments, 'max_calories');
      final minProtein = _getDouble(arguments, 'min_protein');

      // Validate numeric filters.
      if (minCalories != null && minCalories < 0) {
        return _failure('Minimum calories cannot be negative.');
      }

      if (maxCalories != null && maxCalories < 0) {
        return _failure('Maximum calories cannot be negative.');
      }

      if (minProtein != null && minProtein < 0) {
        return _failure('Minimum protein cannot be negative.');
      }

      if (minCalories != null &&
          maxCalories != null &&
          minCalories > maxCalories) {
        return _failure('Minimum calories cannot exceed maximum calories.');
      }

      final meals = await _dataSource.searchMeals(
        query: query,
        minCalories: minCalories,
        maxCalories: maxCalories,
        minProtein: minProtein,
      );

      if (meals.isEmpty) {
        return _success({
          'count': 0,
          'meals': [],
          'message': 'No meals found matching your criteria.',
        });
      }

      return _success({
        'count': meals.length,
        'meals': meals.map((meal) => meal.toJson()).toList(),
      });
    } catch (e) {
      return _failure('Failed to search meals: $e');
    }
  }

  Future<Map<String, dynamic>> getMealDetails(
    Map<String, dynamic> arguments,
  ) async {
    try {
      final mealId = _getString(arguments, 'meal_id');

      if (mealId == null) {
        return _failure('Meal ID is required.');
      }

      final meal = await _dataSource.getMealById(mealId);

      if (meal == null) {
        return _failure('Meal not found.');
      }

      final ingredients = await _dataSource.getMealIngredients(mealId);

      final steps = await _dataSource.getMealSteps(mealId);

      return _success({
        'meal': meal.toJson(),
        'ingredients': ingredients
            .map((ingredient) => ingredient.toJson())
            .toList(),
        'steps': steps.map((step) => step.toJson()).toList(),
      });
    } catch (e) {
      return _failure('Failed to get meal details: $e');
    }
  }

  // Argument helpers

  String? _getString(Map<String, dynamic> arguments, String key) {
    final value = arguments[key];

    if (value is! String) return null;

    final trimmed = value.trim();

    return trimmed.isEmpty ? null : trimmed;
  }

  double? _getDouble(Map<String, dynamic> arguments, String key) {
    final value = arguments[key];

    if (value == null) return null;
    if (value is num) return value.toDouble();

    return double.tryParse(value.toString());
  }

  // Result helpers

  Map<String, dynamic> _success(Map<String, dynamic> data) {
    return {'success': true, 'data': data};
  }

  Map<String, dynamic> _failure(String message) {
    return {'success': false, 'error': message};
  }
}
