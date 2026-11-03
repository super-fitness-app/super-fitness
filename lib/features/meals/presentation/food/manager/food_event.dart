part of 'food_cubit.dart';

sealed class FoodEvent {
  const FoodEvent();
}

final class LoadFoodDataEvent extends FoodEvent {
  const LoadFoodDataEvent();
}

final class SelectCategoryEvent extends FoodEvent {
  final String categoryName;
  const SelectCategoryEvent(this.categoryName);
}

final class LoadMoreMealsEvent extends FoodEvent {
  const LoadMoreMealsEvent();
}

final class MealClickedEvent extends FoodEvent {
  final MealEntity meal;
  const MealClickedEvent(this.meal);
}

final class RefreshFoodEvent extends FoodEvent {
  const RefreshFoodEvent();
}
