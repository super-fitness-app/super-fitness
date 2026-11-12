import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/contract/fitness_local_data_source.dart';
import 'package:super_fitness/features/ai_chat/data/models/meal_model.dart';
import 'package:super_fitness/features/ai_chat/data/tools/nutrition/nutrition_tools.dart';

class MockFitnessLocalDataSource extends Mock
    implements FitnessLocalDataSource {
  @override
  Future<List<MealModel>> searchMeals({
    String? query,
    double? minCalories,
    double? maxCalories,
    double? minProtein,
  }) =>
      super.noSuchMethod(
            Invocation.method(#searchMeals, [], {
              #query: query,
              #minCalories: minCalories,
              #maxCalories: maxCalories,
              #minProtein: minProtein,
            }),
            returnValue: Future.value(<MealModel>[]),
          )
          as Future<List<MealModel>>;

  @override
  Future<MealModel?> getMealById(String? id) =>
      super.noSuchMethod(
            Invocation.method(#getMealById, [id]),
            returnValue: Future.value(null),
          )
          as Future<MealModel?>;
}

void main() {
  late MockFitnessLocalDataSource mockDataSource;
  late NutritionTools tools;

  setUp(() {
    mockDataSource = MockFitnessLocalDataSource();
    tools = NutritionTools(mockDataSource);
  });

  group('NutritionTools Tests', () {
    test('returns failure when minCalories is negative', () async {
      final res = await tools.searchMeals({'min_calories': -10});
      expect(res['success'], isFalse);
      expect(res['error'], contains('cannot be negative'));
    });

    test('returns failure when maxCalories is negative', () async {
      final res = await tools.searchMeals({'max_calories': -50});
      expect(res['success'], isFalse);
      expect(res['error'], contains('cannot be negative'));
    });

    test('returns failure when minCalories exceeds maxCalories', () async {
      final res = await tools.searchMeals({
        'min_calories': 500,
        'max_calories': 200,
      });
      expect(res['success'], isFalse);
      expect(res['error'], contains('cannot exceed'));
    });

    test('returns empty message when no meals match', () async {
      when(
        mockDataSource.searchMeals(
          query: anyNamed('query'),
          minCalories: anyNamed('minCalories'),
          maxCalories: anyNamed('maxCalories'),
          minProtein: anyNamed('minProtein'),
        ),
      ).thenAnswer((_) async => []);

      final res = await tools.searchMeals({'query': 'unicorn'});
      expect(res['success'], isTrue);
      expect(res['data']['count'], equals(0));
      expect(res['data']['message'], contains('No meals found'));
    });

    test('getMealDetails returns error when mealId is missing', () async {
      final res = await tools.getMealDetails({});
      expect(res['success'], isFalse);
      expect(res['error'], contains('Meal ID is required'));
    });
  });
}
