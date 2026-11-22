part of 'home_cubit.dart';

abstract base class HomeEvent extends FeatureEvent {
  const HomeEvent();
}

final class GetHomeDataEvent extends HomeEvent {
  const GetHomeDataEvent();
}

final class SelectMuscleGroupEvent extends HomeEvent {
  final String groupId;
  const SelectMuscleGroupEvent(this.groupId);
}

final class RefreshRandomMusclesEvent extends HomeEvent {
  const RefreshRandomMusclesEvent();
}

final class RefreshPopularTrainingEvent extends HomeEvent {
  const RefreshPopularTrainingEvent();
}

final class RefreshHomeDataEvent extends HomeEvent {
  const RefreshHomeDataEvent();
}
