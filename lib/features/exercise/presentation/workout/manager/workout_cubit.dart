import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';

part 'workout_event.dart';
part 'workout_state.dart';

@injectable
class WorkoutCubit extends BaseCubit<WorkoutState, BaseEvent> {
  final ExerciseRepo? _exerciseRepo;

  WorkoutCubit([this._exerciseRepo])
    : super(const BaseState<WorkoutData>.initial());

  @override
  void doEvent(Object event) {
    switch (event) {
      case GetWorkoutsEvent():
        _onGetWorkouts(event);
      default:
        break;
    }
  }

  ExerciseRepo? _onGetWorkouts(GetWorkoutsEvent event) {
    final response = _exerciseRepo;
    return response;
  }
}
