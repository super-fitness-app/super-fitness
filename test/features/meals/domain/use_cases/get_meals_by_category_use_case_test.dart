import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/features/meals/domain/entities/category_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/meals/domain/repo/meals_repo.dart';
import 'package:super_fitness/features/meals/domain/use_cases/get_meals_by_category_use_case.dart';

class FakeMealsRepo implements MealsRepo {
  String? requestedCategory;
  ApiResults<List<MealEntity>> mealsResult = const Success([]);

  @override
  Future<ApiResults<List<CategoryEntity>>> getCategories() async =>
      const Success([]);

  @override
  Future<ApiResults<List<MealEntity>>> getMealsByCategory(String category) async {
    requestedCategory = category;
    return mealsResult;
  }

  @override
  Future<ApiResults<MealDetailsEntity>> getMealDetails(String mealId) async =>
      const Success(MealDetailsEntity());
}

void main() {
  late FakeMealsRepo repo;
  late GetMealsByCategoryUseCase useCase;

  setUp(() {
    repo = FakeMealsRepo();
    useCase = GetMealsByCategoryUseCase(repo);
  });

  group('GetMealsByCategoryUseCase Tests', () {
    test('delegates call with correct category argument and returns Success', () async {
      const meals = [
        MealEntity(id: '10', name: 'Fish Pie', imageUrl: ''),
      ];
      repo.mealsResult = const Success(meals);

      final result = await useCase('Seafood');

      expect(repo.requestedCategory, 'Seafood');
      expect(result, isA<Success<List<MealEntity>>>());
      expect((result as Success<List<MealEntity>>).data, meals);
    });

    test('delegates call and returns Failure on error', () async {
      repo.mealsResult = const Failure(NetworkFailure(AppError.server));

      final result = await useCase('Beef');

      expect(repo.requestedCategory, 'Beef');
      expect(result, isA<Failure<List<MealEntity>>>());
      final failure = (result as Failure<List<MealEntity>>).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).error, AppError.server);
    });
  });
}
