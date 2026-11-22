import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/meals/data/mapper/meals_mapper.dart';
import 'package:super_fitness/features/meals/data/models/categories_response.dart';
import 'package:super_fitness/features/meals/data/models/meals_details_response.dart';
import 'package:super_fitness/features/meals/data/models/meals_response.dart';
import 'package:super_fitness/features/meals/domain/entities/category_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';

void main() {
  late MealsMapper mapper;

  setUp(() {
    mapper = MealsMapper();
  });

  group('MealsMapper Tests', () {
    test('mapCategoryListToEntityList maps DTOs to entities correctly', () {
      const dtoList = [
        Category(
          id: '1',
          name: 'Breakfast',
          imageUrl: 'https://example.com/breakfast.jpg',
          description: 'Morning meals',
        ),
        Category(
          id: '2',
          name: 'Lunch',
          imageUrl: 'https://example.com/lunch.jpg',
          description: 'Noon meals',
        ),
      ];

      final entities = mapper.mapCategoryListToEntityList(dtoList);

      expect(entities.length, 2);
      expect(
        entities[0],
        const CategoryEntity(
          id: '1',
          name: 'Breakfast',
          imageUrl: 'https://example.com/breakfast.jpg',
          description: 'Morning meals',
        ),
      );
      expect(entities[1].name, 'Lunch');
    });

    test('mapCategoryListToEntityList returns empty list for empty input', () {
      final entities = mapper.mapCategoryListToEntityList([]);
      expect(entities, isEmpty);
    });

    test('mapMealListToEntityList maps DTOs to entities correctly', () {
      const dtoList = [
        Meal(id: '101', name: 'Pasta', imageUrl: 'https://example.com/pasta.jpg'),
        Meal(id: '102', name: 'Salad', imageUrl: 'https://example.com/salad.jpg'),
      ];

      final entities = mapper.mapMealListToEntityList(dtoList);

      expect(entities.length, 2);
      expect(
        entities[0],
        const MealEntity(
          id: '101',
          name: 'Pasta',
          imageUrl: 'https://example.com/pasta.jpg',
        ),
      );
      expect(entities[1].name, 'Salad');
    });

    test('mapMealListToEntityList returns empty list for empty input', () {
      final entities = mapper.mapMealListToEntityList([]);
      expect(entities, isEmpty);
    });

    test('mapMealDetailsToEntity maps details and extracts ingredients safely', () {
      const mealDto = MealDetails(
        id: '52772',
        name: 'Teriyaki Chicken Casserole',
        category: 'Chicken',
        area: 'Japanese',
        instructions: 'Preheat oven...',
        imageUrl: 'https://example.com/teriyaki.jpg',
        youtubeUrl: 'https://youtube.com/watch?v=123',
        sourceUrl: 'https://recipe.com/123',
        ingredients: [
          MealIngredient(name: 'soy sauce', measure: '3/4 cup'),
          MealIngredient(name: 'water', measure: '1/2 cup'),
          MealIngredient(name: null, measure: '1 tsp'),
          MealIngredient(name: '   ', measure: 'pinch'),
          MealIngredient(name: 'chicken', measure: null),
        ],
      );

      final entity = mapper.mapMealDetailsToEntity(mealDto);

      expect(entity.id, '52772');
      expect(entity.name, 'Teriyaki Chicken Casserole');
      expect(entity.category, 'Chicken');
      expect(entity.area, 'Japanese');
      expect(entity.instructions, 'Preheat oven...');
      expect(entity.imageUrl, 'https://example.com/teriyaki.jpg');
      expect(entity.youtubeUrl, 'https://youtube.com/watch?v=123');
      expect(entity.sourceUrl, 'https://recipe.com/123');
      expect(entity.ingredients.length, 3);
      expect(
        entity.ingredients[0],
        const MealIngredientEntity(name: 'soy sauce', measure: '3/4 cup'),
      );
      expect(
        entity.ingredients[1],
        const MealIngredientEntity(name: 'water', measure: '1/2 cup'),
      );
      expect(
        entity.ingredients[2],
        const MealIngredientEntity(name: 'chicken', measure: null),
      );
    });

    test('mapMealDetailsToEntity handles empty ingredients list safely', () {
      const mealDto = MealDetails(
        id: '1',
        name: 'Plain Toast',
        ingredients: [],
      );

      final entity = mapper.mapMealDetailsToEntity(mealDto);

      expect(entity.id, '1');
      expect(entity.name, 'Plain Toast');
      expect(entity.ingredients, isEmpty);
    });
  });
}
