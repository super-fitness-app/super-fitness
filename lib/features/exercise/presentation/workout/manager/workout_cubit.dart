import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';

part 'workout_event.dart';
part 'workout_state.dart';

@injectable
class WorkoutCubit extends BaseCubit<WorkoutState, BaseEvent> {
  WorkoutCubit() : super(const BaseState<WorkoutData>.initial());

  @override
  void doEvent(Object event) {
    switch (event) {
      case GetWorkoutsEvent():
        _onGetWorkouts(event);
      default:
        break;
    }
  }

  void _onGetWorkouts(GetWorkoutsEvent event) {}
}
