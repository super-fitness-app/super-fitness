part of 'workout_cubit.dart';

sealed class WorkoutEvent extends FeatureEvent {
  const WorkoutEvent();
}

final class FetchMuscleGroupsEvent extends WorkoutEvent {
  const FetchMuscleGroupsEvent();
}

final class SelectMuscleGroupEvent extends WorkoutEvent {
  final String groupId;

  const SelectMuscleGroupEvent(this.groupId);
}
