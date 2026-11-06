import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/exercise/domain/use_case/get_muscle_groups_use_case.dart';
import 'package:super_fitness/features/exercise/domain/use_case/get_muscles_by_group_use_case.dart';

part 'workout_event.dart';
part 'workout_state.dart';

@injectable
class WorkoutCubit extends BaseCubit<WorkoutState, BaseEvent> {
  final GetMuscleGroupsUseCase _getMuscleGroupsUseCase;
  final GetMusclesByGroupUseCase _getMusclesByGroupUseCase;

  WorkoutCubit(this._getMuscleGroupsUseCase, this._getMusclesByGroupUseCase)
    : super(const BaseState<WorkoutData>.initial());

  @override
  void doEvent(Object event) {
    switch (event) {
      case FetchMuscleGroupsEvent():
        _onFetchMuscleGroups();
      case SelectMuscleGroupEvent(:final groupId):
        _onSelectMuscleGroup(groupId);
    }
  }

  Future<void> _onFetchMuscleGroups() async {
    emit(BaseState<WorkoutData>.loading(data: state.data));
    final result = await _getMuscleGroupsUseCase();
    switch (result) {
      case Success(:final data):
        final firstId = data.isNotEmpty ? data.first.id : null;
        final updated = (state.data ?? const WorkoutData()).copyWith(
          groups: data,
          selectedGroupId: firstId,
        );
        emit(BaseState<WorkoutData>.success(updated));
        if (firstId != null) _fetchMusclesForGroup(firstId);
      case FailureResponse(:final failure):
        emit(BaseState<WorkoutData>.failure(failure, data: state.data));
        emitEvent(DisplayError.fromFailure(failure));
    }
  }

  Future<void> _onSelectMuscleGroup(String groupId) async {
    if (state.data?.selectedGroupId == groupId &&
        (state.data?.muscles.isNotEmpty ?? false)) {
      return;
    }
    await _fetchMusclesForGroup(groupId);
  }

  Future<void> _fetchMusclesForGroup(String groupId) async {
    final updated = (state.data ?? const WorkoutData()).copyWith(
      selectedGroupId: groupId,
      muscles: [],
    );
    emit(BaseState<WorkoutData>.loading(data: updated));
    final result = await _getMusclesByGroupUseCase(groupId);
    switch (result) {
      case Success(:final data):
        final withMuscles = (state.data ?? const WorkoutData()).copyWith(
          selectedGroupId: groupId,
          muscles: data,
        );
        emit(BaseState<WorkoutData>.success(withMuscles));
      case FailureResponse(:final failure):
        emit(BaseState<WorkoutData>.failure(failure, data: state.data));
        emitEvent(DisplayError.fromFailure(failure));
    }
  }
}
