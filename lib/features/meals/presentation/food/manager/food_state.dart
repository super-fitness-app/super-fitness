part of 'food_cubit.dart';

typedef FoodState = BaseState<FoodData>;

class FoodData extends Equatable {
  const FoodData();

  FoodData copyWith() {
    return const FoodData();
  }

  @override
  List<Object?> get props => [];
}

