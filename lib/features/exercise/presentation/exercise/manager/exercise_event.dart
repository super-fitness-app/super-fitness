part of 'exercise_cubit.dart';

abstract base class ExerciseEvent extends FeatureEvent {
  const ExerciseEvent();
}

final class GetExerciseDataEvent extends ExerciseEvent {
  const GetExerciseDataEvent();
}

