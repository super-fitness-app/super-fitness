part of 'food_cubit.dart';

class FoodState extends Equatable {
  final BaseState<List<MealEntity>> baseState;
  final List<CategoryEntity> categories;
  final List<MealEntity> allCategoryMeals;
  final List<MealEntity> displayedMeals;
  final String selectedCategory;
  final bool isLoadingMore;
  final bool hasReachedMax;

  const FoodState({
    this.baseState = const BaseState.initial(),
    this.categories = const [],
    this.allCategoryMeals = const [],
    this.displayedMeals = const [],
    this.selectedCategory = '',
    this.isLoadingMore = false,
    this.hasReachedMax = false,
  });

  List<MealEntity> get meals => displayedMeals;
  bool get isLoading => baseState.isLoading;
  AppFailure? get failure => baseState.failure;

  FoodState copyWith({
    BaseState<List<MealEntity>>? baseState,
    List<CategoryEntity>? categories,
    List<MealEntity>? allCategoryMeals,
    List<MealEntity>? displayedMeals,
    String? selectedCategory,
    bool? isLoadingMore,
    bool? hasReachedMax,
  }) {
    return FoodState(
      baseState: baseState ?? this.baseState,
      categories: categories ?? this.categories,
      allCategoryMeals: allCategoryMeals ?? this.allCategoryMeals,
      displayedMeals: displayedMeals ?? this.displayedMeals,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object?> get props => [
        baseState,
        categories,
        allCategoryMeals,
        displayedMeals,
        selectedCategory,
        isLoadingMore,
        hasReachedMax,
      ];
}

