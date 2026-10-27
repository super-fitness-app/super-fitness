import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';

part 'exercise_event.dart';
part 'exercise_state.dart';

@injectable
class ExerciseCubit extends BaseCubit<ExerciseState, BaseEvent> {
  final ExerciseRepo? _exerciseRepo;

  ExerciseCubit([this._exerciseRepo])
      : super(const BaseState<ExerciseData>.initial());

  @override
  void doEvent(Object event) {
    switch (event) {
      case GetExerciseDataEvent():
        _onGetExerciseData(event);
      default:
        break;
    }
  }

  void _onGetExerciseData(GetExerciseDataEvent event) {}
}

