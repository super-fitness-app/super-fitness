part of 'food_cubit.dart';

abstract base class FoodEvent extends FeatureEvent {
  const FoodEvent();
}

final class GetFoodDataEvent extends FoodEvent {
  const GetFoodDataEvent();
}

