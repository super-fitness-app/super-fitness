part of 'food_details_cubit.dart';

abstract base class FoodDetailsEvent extends FeatureEvent {
  const FoodDetailsEvent();
}

final class GetFoodDetailsDataEvent extends FoodDetailsEvent {
  const GetFoodDetailsDataEvent();
}

