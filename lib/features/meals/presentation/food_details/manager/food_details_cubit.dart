import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';
import 'package:super_fitness/features/meals/domain/use_cases/get_meal_details_use_case.dart';

part 'food_details_event.dart';
part 'food_details_state.dart';

@injectable
class FoodDetailsCubit extends BaseCubit<FoodDetailsState, BaseEvent> {
  final GetMealDetailsUseCase _getMealDetailsUseCase;

  FoodDetailsCubit(this._getMealDetailsUseCase)
      : super(const BaseState.initial());

  @override
  void doEvent(Object event) {
    switch (event) {
      case LoadMealDetailsEvent(:final mealId):
        _onLoadMealDetails(mealId);
      default:
        break;
    }
  }

  Future<void> _onLoadMealDetails(String mealId) async {
    emit(const BaseState.loading());
    final result = await _getMealDetailsUseCase(mealId);
    switch (result) {
      case Success(:final data):
        emit(BaseState.success(data));
      case Failure(:final failure):
        emit(BaseState.failure(failure));
        emitEvent(DisplayError.fromFailure(failure));
    }
  }
}
