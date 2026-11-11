import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/ai_chat/data/models/meal_model.dart';

void main() {
  group('MealModel SQLite Row Deserialization', () {
    test('successfully parses SQLite row with integer 0/1 boolean columns', () {
      final sqliteRow = <String, dynamic>{
        'id': 'meal_123',
        'name': 'Grilled Chicken Salad',
        'name_ar': 'سلطة دجاج مشوي',
        'category': 'Salad',
        'area': 'Mediterranean',
        'meal_type': 'Lunch',
        'kcal': 350.0,
        'protein_g': 40.0,
        'carbs_g': 12.0,
        'fat_g': 8.0,
        'nutrition_is_estimate': 1, // SQLite stores boolean as integer 1
        'nutrition_confidence': 0.95,
        'vegetarian': 0, // SQLite stores boolean as integer 0
        'vegan': 0,
        'contains_gluten': 0,
        'contains_nuts': 1,
        'ingredient_count': 6,
        'thumb': 'https://example.com/thumb.jpg',
        'youtube': 'https://youtube.com/watch?v=123',
        'tags': 'healthy,low-carb',
        'popularity': 90,
      };

      final model = MealModel.fromJson(sqliteRow);

      expect(model.id, equals('meal_123'));
      expect(model.name, equals('grilled chicken salad'));
      expect(model.nutritionIsEstimate, isTrue);
      expect(model.vegetarian, isFalse);
      expect(model.vegan, isFalse);
      expect(model.containsGluten, isFalse);
      expect(model.containsNuts, isTrue);
      expect(model.calories, equals(350.0));
      expect(model.protein, equals(40.0));
    });

    test('successfully handles null and boolean values as well', () {
      final rowWithBoolsAndNulls = <String, dynamic>{
        'id': 'meal_456',
        'name': 'Avocado Toast',
        'nutrition_is_estimate': null,
        'vegetarian': true,
        'vegan': false,
        'contains_gluten': null,
        'contains_nuts': false,
      };

      final model = MealModel.fromJson(rowWithBoolsAndNulls);

      expect(model.id, equals('meal_456'));
      expect(model.nutritionIsEstimate, isNull);
      expect(model.vegetarian, isTrue);
      expect(model.vegan, isFalse);
      expect(model.containsGluten, isNull);
      expect(model.containsNuts, isFalse);
    });
  });
}
