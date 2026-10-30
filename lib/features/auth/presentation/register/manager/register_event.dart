part of 'register_cubit.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

final class SubmitBasicInfoEvent extends RegisterEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String? rePassword;

  const SubmitBasicInfoEvent({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.password,
    this.rePassword,
  });

  @override
  List<Object?> get props => [
    firstName,
    lastName,
    email,
    password,
    rePassword,
  ];
}

final class UpdateGenderEvent extends RegisterEvent {
  final String gender;

  const UpdateGenderEvent(this.gender);

  @override
  List<Object?> get props => [gender];
}

final class UpdateAgeEvent extends RegisterEvent {
  final int age;

  const UpdateAgeEvent(this.age);

  @override
  List<Object?> get props => [age];
}

final class UpdateWeightEvent extends RegisterEvent {
  final int weight;

  const UpdateWeightEvent(this.weight);

  @override
  List<Object?> get props => [weight];
}

final class UpdateHeightEvent extends RegisterEvent {
  final int height;

  const UpdateHeightEvent(this.height);

  @override
  List<Object?> get props => [height];
}

final class UpdateGoalEvent extends RegisterEvent {
  final String goal;

  const UpdateGoalEvent(this.goal);

  @override
  List<Object?> get props => [goal];
}

final class UpdateActivityLevelEvent extends RegisterEvent {
  final String activityLevel;

  const UpdateActivityLevelEvent(this.activityLevel);

  @override
  List<Object?> get props => [activityLevel];
}

final class SubmitFinalRegistrationEvent extends RegisterEvent {
  const SubmitFinalRegistrationEvent();
}

final class ResetRegistrationEvent extends RegisterEvent {
  const ResetRegistrationEvent();
}
