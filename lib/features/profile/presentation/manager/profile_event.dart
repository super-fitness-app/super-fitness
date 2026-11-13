part of 'profile_cubit.dart';

abstract base class ProfileEvent extends FeatureEvent {
  const ProfileEvent();
}

final class UpdateWeightEvent extends ProfileEvent {
  final double weight;
  const UpdateWeightEvent(this.weight);
}

final class UpdateGoalEvent extends ProfileEvent {
  final String goal;
  const UpdateGoalEvent(this.goal);
}

final class UpdateActivityEvent extends ProfileEvent {
  final String activityLevel;
  const UpdateActivityEvent(this.activityLevel);
}

final class SaveProfileEvent extends ProfileEvent {
  const SaveProfileEvent();
}
