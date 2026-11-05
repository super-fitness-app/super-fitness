import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/features/meals/domain/entities/category_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/meals/domain/use_cases/get_categories_use_case.dart';
import 'package:super_fitness/features/meals/domain/use_cases/get_meals_by_category_use_case.dart';

part 'food_event.dart';
part 'food_state.dart';

@injectable
class FoodCubit extends BaseCubit<FoodState, BaseEvent> {
  static const int _pageSize = 10;
  final GetCategoriesUseCase _getCategoriesUseCase;
  final GetMealsByCategoryUseCase _getMealsByCategoryUseCase;

  FoodCubit(
    this._getCategoriesUseCase,
    this._getMealsByCategoryUseCase,
  ) : super(const FoodState());

  @override
  void doEvent(Object event) {
    switch (event) {
      case LoadFoodDataEvent():
        _onLoadFoodData();
      case SelectCategoryEvent(:final categoryName):
        _onSelectCategory(categoryName);
      case LoadMoreMealsEvent():
        _onLoadMoreMeals();
      case MealClickedEvent(:final meal):
        _onMealClicked(meal);
      case RefreshFoodEvent():
        _onRefreshFood();
      default:
        break;
    }
  }

  Future<void> _onLoadFoodData() async {
    emit(state.copyWith(baseState: const BaseState.loading()));
    final result = await _getCategoriesUseCase();
    switch (result) {
      case Success(:final data):
        if (data.isEmpty) {
          emit(state.copyWith(baseState: const BaseState.success([])));
          return;
        }
        final defaultCat = data.first.name ?? '';
        emit(state.copyWith(categories: data, selectedCategory: defaultCat));
        await _loadMealsForCategory(defaultCat);
      case Failure(:final failure):
        emit(state.copyWith(baseState: BaseState.failure(failure)));
        emitEvent(DisplayError.fromFailure(failure));
    }
  }

  Future<void> _loadMealsForCategory(String category) async {
    final result = await _getMealsByCategoryUseCase(category);
    switch (result) {
      case Success(:final data):
        final firstBatch = data.take(_pageSize).toList();
        emit(state.copyWith(
          allCategoryMeals: data,
          displayedMeals: firstBatch,
          hasReachedMax: firstBatch.length >= data.length,
          baseState: BaseState.success(firstBatch),
        ));
      case Failure(:final failure):
        emit(state.copyWith(baseState: BaseState.failure(failure)));
        emitEvent(DisplayError.fromFailure(failure));
    }
  }

  Future<void> _onSelectCategory(String categoryName) async {
    if (categoryName == state.selectedCategory && !state.isLoading) return;
    emit(state.copyWith(
      selectedCategory: categoryName,
      allCategoryMeals: const [],
      displayedMeals: const [],
      isLoadingMore: false,
      hasReachedMax: false,
      baseState: const BaseState.loading(),
    ));
    await _loadMealsForCategory(categoryName);
  }

  void _onLoadMoreMeals() {
    if (state.isLoadingMore || state.hasReachedMax || state.isLoading) return;
    emit(state.copyWith(isLoadingMore: true));
    final currentCount = state.displayedMeals.length;
    final nextBatch =
        state.allCategoryMeals.skip(currentCount).take(_pageSize).toList();
    final updated = List<MealEntity>.from(state.displayedMeals)
      ..addAll(nextBatch);
    emit(state.copyWith(
      displayedMeals: updated,
      isLoadingMore: false,
      hasReachedMax: updated.length >= state.allCategoryMeals.length,
      baseState: BaseState.success(updated),
    ));
  }

  void _onMealClicked(MealEntity meal) {
    emitEvent(NavigateEvent(AppRoutes.foodDetails, extra: meal.id ?? ''));
  }

  Future<void> _onRefreshFood() async {
    if (state.selectedCategory.isNotEmpty) {
      await _loadMealsForCategory(state.selectedCategory);
    } else {
      await _onLoadFoodData();
    }
  }
}

