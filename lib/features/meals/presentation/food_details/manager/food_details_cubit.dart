import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/features/meals/domain/repo/meals_repo.dart';

part 'food_details_event.dart';
part 'food_details_state.dart';

@injectable
class FoodDetailsCubit extends BaseCubit<FoodDetailsState, BaseEvent> {
  final MealsRepo? _mealsRepo;

  FoodDetailsCubit([this._mealsRepo])
    : super(const BaseState<FoodDetailsData>.initial());

  @override
  void doEvent(Object event) {
    switch (event) {
      case GetFoodDetailsDataEvent():
        _onGetFoodDetailsData(event);
      default:
        break;
    }
  }

  MealsRepo? _onGetFoodDetailsData(GetFoodDetailsDataEvent event) {
    final response = _mealsRepo;
    return response;
  }
}
