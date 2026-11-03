import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/features/meals/domain/entities/category_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/meals/domain/repo/meals_repo.dart';
import 'package:super_fitness/features/meals/domain/use_cases/get_meal_details_use_case.dart';
import 'package:super_fitness/features/meals/presentation/food_details/manager/food_details_cubit.dart';

class FakeMealsRepo implements MealsRepo {
  ApiResults<MealDetailsEntity> mealDetailsResult =
      const Success(MealDetailsEntity());
  String? lastRequestedId;

  @override
  Future<ApiResults<List<CategoryEntity>>> getCategories() async =>
      const Success([]);

  @override
  Future<ApiResults<List<MealEntity>>> getMealsByCategory(
    String category,
  ) async =>
      const Success([]);

  @override
  Future<ApiResults<MealDetailsEntity>> getMealDetails(String mealId) async {
    lastRequestedId = mealId;
    return mealDetailsResult;
  }
}

void main() {
  group('FoodDetailsCubit Tests', () {
    late FakeMealsRepo repo;
    late GetMealDetailsUseCase useCase;

    const testMealDetails = MealDetailsEntity(
      id: '53380',
      name: 'Apple cake',
      category: 'Dessert',
      instructions: 'Bake it well',
      imageUrl: 'https://example.com/image.jpg',
      youtubeUrl: 'https://www.youtube.com/watch?v=vZy-7UyPdjM',
      ingredients: [
        MealIngredientEntity(name: 'Eggs', measure: '4'),
        MealIngredientEntity(name: 'Sugar', measure: '200g'),
      ],
    );

    setUp(() {
      repo = FakeMealsRepo();
      useCase = GetMealDetailsUseCase(repo);
    });

    test('Initial state is BaseState.initial()', () {
      final cubit = FoodDetailsCubit(useCase);
      expect(cubit.state, const BaseState<MealDetailsEntity>.initial());
      cubit.close();
    });

    blocTest<FoodDetailsCubit, FoodDetailsState>(
      'LoadMealDetailsEvent emits [loading, success] on successful fetch',
      build: () {
        repo.mealDetailsResult = const Success(testMealDetails);
        return FoodDetailsCubit(useCase);
      },
      act: (cubit) => cubit.doEvent(const LoadMealDetailsEvent('53380')),
      expect: () => [
        const BaseState<MealDetailsEntity>.loading(),
        const BaseState<MealDetailsEntity>.success(testMealDetails),
      ],
      verify: (_) {
        expect(repo.lastRequestedId, '53380');
      },
    );

    blocTest<FoodDetailsCubit, FoodDetailsState>(
      'LoadMealDetailsEvent emits [loading, failure] on error',
      build: () {
        repo.mealDetailsResult =
            const Failure(NetworkFailure(AppError.noConnection));
        return FoodDetailsCubit(useCase);
      },
      act: (cubit) => cubit.doEvent(const LoadMealDetailsEvent('53380')),
      expect: () => [
        const BaseState<MealDetailsEntity>.loading(),
        const BaseState<MealDetailsEntity>.failure(
          NetworkFailure(AppError.noConnection),
        ),
      ],
    );

    test('LoadMealDetailsEvent broadcasts DisplayError on failure', () async {
      repo.mealDetailsResult =
          const Failure(NetworkFailure(AppError.noConnection));
      final cubit = FoodDetailsCubit(useCase);
      final events = <BaseEvent>[];
      final sub = cubit.eventStream.listen(events.add);

      cubit.doEvent(const LoadMealDetailsEvent('53380'));
      await Future<void>.delayed(Duration.zero);

      expect(events.length, 1);
      expect(events.first, isA<DisplayError>());

      await sub.cancel();
      await cubit.close();
    });
  });
}
