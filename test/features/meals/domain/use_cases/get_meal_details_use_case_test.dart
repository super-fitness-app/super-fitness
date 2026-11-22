import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/features/meals/domain/entities/category_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/meals/domain/repo/meals_repo.dart';
import 'package:super_fitness/features/meals/domain/use_cases/get_meal_details_use_case.dart';

class FakeMealsRepo implements MealsRepo {
  String? requestedMealId;
  ApiResults<MealDetailsEntity> mealDetailsResult =
      const Success(MealDetailsEntity());

  @override
  Future<ApiResults<List<CategoryEntity>>> getCategories() async =>
      const Success([]);

  @override
  Future<ApiResults<List<MealEntity>>> getMealsByCategory(String category) async =>
      const Success([]);

  @override
  Future<ApiResults<MealDetailsEntity>> getMealDetails(String mealId) async {
    requestedMealId = mealId;
    return mealDetailsResult;
  }
}

void main() {
  late FakeMealsRepo repo;
  late GetMealDetailsUseCase useCase;

  setUp(() {
    repo = FakeMealsRepo();
    useCase = GetMealDetailsUseCase(repo);
  });

  group('GetMealDetailsUseCase Tests', () {
    test('delegates call with correct mealId argument and returns Success', () async {
      const details = MealDetailsEntity(
        id: '52772',
        name: 'Teriyaki Chicken Casserole',
      );
      repo.mealDetailsResult = const Success(details);

      final result = await useCase('52772');

      expect(repo.requestedMealId, '52772');
      expect(result, isA<Success<MealDetailsEntity>>());
      expect((result as Success<MealDetailsEntity>).data, details);
    });

    test('delegates call and returns Failure on repository error', () async {
      repo.mealDetailsResult = const Failure(NetworkFailure(AppError.badRequest));

      final result = await useCase('99999');

      expect(repo.requestedMealId, '99999');
      expect(result, isA<Failure<MealDetailsEntity>>());
      final failure = (result as Failure<MealDetailsEntity>).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).error, AppError.badRequest);
    });
  });
}
