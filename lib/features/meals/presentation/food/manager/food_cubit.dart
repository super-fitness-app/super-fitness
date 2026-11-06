import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/features/meals/domain/repo/meals_repo.dart';

part 'food_event.dart';
part 'food_state.dart';

@injectable
class FoodCubit extends BaseCubit<FoodState, BaseEvent> {
  final MealsRepo _mealsRepo;

  FoodCubit(this._mealsRepo) : super(const BaseState<FoodData>.initial());

  MealsRepo get repo => _mealsRepo;

  @override
  void doEvent(Object event) {
    switch (event) {
      case GetFoodDataEvent():
        _onGetFoodData(event);
      default:
        break;
    }
  }

  void _onGetFoodData(GetFoodDataEvent event) {}
}
