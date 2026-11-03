part of 'food_details_cubit.dart';

sealed class FoodDetailsEvent extends FeatureEvent {
  const FoodDetailsEvent();
}

final class LoadMealDetailsEvent extends FoodDetailsEvent {
  final String mealId;
  const LoadMealDetailsEvent(this.mealId);
}
