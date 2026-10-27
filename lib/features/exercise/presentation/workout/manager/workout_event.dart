part of 'workout_cubit.dart';

abstract base class WorkoutEvent extends FeatureEvent {
  const WorkoutEvent();
}

final class GetWorkoutsEvent extends WorkoutEvent {
  const GetWorkoutsEvent();
}

