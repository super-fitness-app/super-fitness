import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/features/meals/domain/entities/category_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/meals/domain/repo/meals_repo.dart';
import 'package:super_fitness/features/meals/domain/use_cases/get_categories_use_case.dart';
import 'package:super_fitness/features/meals/domain/use_cases/get_meals_by_category_use_case.dart';
import 'package:super_fitness/features/meals/presentation/food/manager/food_cubit.dart';

class FakeMealsRepo implements MealsRepo {
  ApiResults<List<CategoryEntity>> categoriesResult = const Success([]);
  ApiResults<List<MealEntity>> mealsResult = const Success([]);

  String? lastRequestedCategory;

  @override
  Future<ApiResults<List<CategoryEntity>>> getCategories() async =>
      categoriesResult;

  @override
  Future<ApiResults<List<MealEntity>>> getMealsByCategory(
    String category,
  ) async {
    lastRequestedCategory = category;
    return mealsResult;
  }

  @override
  Future<ApiResults<MealDetailsEntity>> getMealDetails(String mealId) async =>
      const Success(MealDetailsEntity());
}

void main() {
  group('FoodCubit Tests', () {
    late FakeMealsRepo repo;
    late GetCategoriesUseCase getCategoriesUseCase;
    late GetMealsByCategoryUseCase getMealsByCategoryUseCase;

    const testCategories = [
      CategoryEntity(id: '1', name: 'Breakfast'),
      CategoryEntity(id: '2', name: 'Lunch'),
      CategoryEntity(id: '3', name: 'Dinner'),
    ];

    const testMeals = [
      MealEntity(id: '101', name: 'Pasta With Chicks', imageUrl: 'url1'),
      MealEntity(id: '102', name: 'Steak', imageUrl: 'url2'),
    ];

    setUp(() {
      repo = FakeMealsRepo();
      getCategoriesUseCase = GetCategoriesUseCase(repo);
      getMealsByCategoryUseCase = GetMealsByCategoryUseCase(repo);
    });

    test('initial state has empty selectedCategory and initial baseState', () {
      final cubit = FoodCubit(getCategoriesUseCase, getMealsByCategoryUseCase);
      expect(cubit.state.selectedCategory, isEmpty);
      expect(cubit.state.categories, isEmpty);
      expect(cubit.state.meals, isEmpty);
      expect(cubit.state.isLoading, isFalse);
      cubit.close();
    });

    blocTest<FoodCubit, FoodState>(
      'LoadFoodDataEvent defaults to categories.first.name and loads meals',
      setUp: () {
        repo.categoriesResult = const Success(testCategories);
        repo.mealsResult = const Success(testMeals);
      },
      build: () => FoodCubit(getCategoriesUseCase, getMealsByCategoryUseCase),
      act: (cubit) => cubit.doEvent(const LoadFoodDataEvent()),
      expect: () => [
        const FoodState(baseState: BaseState.loading()),
        const FoodState(
          baseState: BaseState.loading(),
          categories: testCategories,
          selectedCategory: 'Breakfast',
        ),
        const FoodState(
          baseState: BaseState.success(testMeals),
          categories: testCategories,
          selectedCategory: 'Breakfast',
          allCategoryMeals: testMeals,
          displayedMeals: testMeals,
          hasReachedMax: true,
        ),
      ],
      verify: (_) {
        expect(repo.lastRequestedCategory, 'Breakfast');
      },
    );

    blocTest<FoodCubit, FoodState>(
      'LoadFoodDataEvent emits failure state and broadcasts DisplayError',
      setUp: () {
        repo.categoriesResult = const Failure(NetworkFailure(AppError.noConnection));
      },
      build: () => FoodCubit(getCategoriesUseCase, getMealsByCategoryUseCase),
      act: (cubit) => cubit.doEvent(const LoadFoodDataEvent()),
      expect: () => [
        const FoodState(baseState: BaseState.loading()),
        const FoodState(
          baseState: BaseState.failure(NetworkFailure(AppError.noConnection)),
        ),
      ],
      verify: (cubit) {
        expect(cubit.state.failure, const NetworkFailure(AppError.noConnection));
      },
    );

    blocTest<FoodCubit, FoodState>(
      'SelectCategoryEvent immediately emits loading before new meals',
      setUp: () {
        repo.mealsResult = const Success(testMeals);
      },
      build: () => FoodCubit(getCategoriesUseCase, getMealsByCategoryUseCase),
      seed: () => const FoodState(
        categories: testCategories,
        selectedCategory: 'Breakfast',
        allCategoryMeals: testMeals,
        displayedMeals: testMeals,
      ),
      act: (cubit) => cubit.doEvent(const SelectCategoryEvent('Dinner')),
      expect: () => [
        const FoodState(
          baseState: BaseState.loading(),
          categories: testCategories,
          selectedCategory: 'Dinner',
        ),
        const FoodState(
          baseState: BaseState.success(testMeals),
          categories: testCategories,
          selectedCategory: 'Dinner',
          allCategoryMeals: testMeals,
          displayedMeals: testMeals,
          hasReachedMax: true,
        ),
      ],
      verify: (_) {
        expect(repo.lastRequestedCategory, 'Dinner');
      },
    );

    final fifteenMeals = List.generate(
      15,
      (i) => MealEntity(id: '$i', name: 'Meal $i', imageUrl: 'url$i'),
    );

    blocTest<FoodCubit, FoodState>(
      'LoadMoreMealsEvent slices next batch of meals and sets hasReachedMax',
      build: () => FoodCubit(getCategoriesUseCase, getMealsByCategoryUseCase),
      seed: () => FoodState(
        categories: testCategories,
        selectedCategory: 'Lunch',
        allCategoryMeals: fifteenMeals,
        displayedMeals: fifteenMeals.take(10).toList(),
        hasReachedMax: false,
      ),
      act: (cubit) => cubit.doEvent(const LoadMoreMealsEvent()),
      expect: () => [
        FoodState(
          categories: testCategories,
          selectedCategory: 'Lunch',
          allCategoryMeals: fifteenMeals,
          displayedMeals: fifteenMeals.take(10).toList(),
          isLoadingMore: true,
          hasReachedMax: false,
        ),
        FoodState(
          baseState: BaseState.success(fifteenMeals),
          categories: testCategories,
          selectedCategory: 'Lunch',
          allCategoryMeals: fifteenMeals,
          displayedMeals: fifteenMeals,
          isLoadingMore: false,
          hasReachedMax: true,
        ),
      ],
    );

    test('MealClickedEvent broadcasts NavigateEvent to foodDetails', () async {
      final cubit = FoodCubit(getCategoriesUseCase, getMealsByCategoryUseCase);
      final events = <BaseEvent>[];
      final sub = cubit.eventStream.listen(events.add);

      const meal = MealEntity(id: '99', name: 'Burger', imageUrl: 'img');
      cubit.doEvent(const MealClickedEvent(meal));
      await Future<void>.delayed(Duration.zero);

      expect(events.length, 1);
      final navEvent = events.first as NavigateEvent;
      expect(navEvent.routeName, AppRoutes.foodDetails);
      expect(navEvent.extra, meal);

      await sub.cancel();
      await cubit.close();
    });
  });
}

