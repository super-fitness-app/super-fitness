import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/features/meals/domain/entities/category_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/meals/domain/repo/meals_repo.dart';
import 'package:super_fitness/features/meals/domain/use_cases/get_categories_use_case.dart';

class FakeMealsRepo implements MealsRepo {
  ApiResults<List<CategoryEntity>> categoriesResult = const Success([]);

  @override
  Future<ApiResults<List<CategoryEntity>>> getCategories() async =>
      categoriesResult;

  @override
  Future<ApiResults<List<MealEntity>>> getMealsByCategory(String category) async =>
      const Success([]);

  @override
  Future<ApiResults<MealDetailsEntity>> getMealDetails(String mealId) async =>
      const Success(MealDetailsEntity());
}

void main() {
  late FakeMealsRepo repo;
  late GetCategoriesUseCase useCase;

  setUp(() {
    repo = FakeMealsRepo();
    useCase = GetCategoriesUseCase(repo);
  });

  group('GetCategoriesUseCase Tests', () {
    test('delegates call to MealsRepo and returns Success', () async {
      const categories = [
        CategoryEntity(id: '1', name: 'Dessert'),
      ];
      repo.categoriesResult = const Success(categories);

      final result = await useCase();

      expect(result, isA<Success<List<CategoryEntity>>>());
      expect((result as Success<List<CategoryEntity>>).data, categories);
    });

    test('delegates call to MealsRepo and returns Failure', () async {
      repo.categoriesResult = const Failure(NetworkFailure(AppError.noConnection));

      final result = await useCase();

      expect(result, isA<Failure<List<CategoryEntity>>>());
      final failure = (result as Failure<List<CategoryEntity>>).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).error, AppError.noConnection);
    });
  });
}
