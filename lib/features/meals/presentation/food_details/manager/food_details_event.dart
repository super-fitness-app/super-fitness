part of 'food_details_cubit.dart';

sealed class FoodDetailsEvent {
  const FoodDetailsEvent();
}

final class LoadMealDetailsEvent extends FoodDetailsEvent {
  final String mealId;
  const LoadMealDetailsEvent(this.mealId);
}
