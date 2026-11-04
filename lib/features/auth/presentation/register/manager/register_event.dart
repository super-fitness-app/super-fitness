part of 'register_cubit.dart';

sealed class RegisterEvent extends Equatable {
  const RegisterEvent();

  @override
  List<Object?> get props => [];
}

// =============================================================================
// PHASE 1: Basic Info Event (Screen 1)
// =============================================================================

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
  List<Object?> get props => [firstName, lastName, email, password, rePassword];
}

// =============================================================================
// PHASE 2: Multi-step Registration Events (Screens 2 - 6 & Final Submission)
// =============================================================================

/// Step 2: Gender selection event
final class UpdateGenderEvent extends RegisterEvent {
  final String gender;
  const UpdateGenderEvent(this.gender);

  @override
  List<Object?> get props => [gender];
}

/// Step 3: Age selection event
final class UpdateAgeEvent extends RegisterEvent {
  final int age;
  const UpdateAgeEvent(this.age);

  @override
  List<Object?> get props => [age];
}

/// Step 4: Weight selection event
final class UpdateWeightEvent extends RegisterEvent {
  final int weight;
  const UpdateWeightEvent(this.weight);

  @override
  List<Object?> get props => [weight];
}

/// Step 5: Height selection event
final class UpdateHeightEvent extends RegisterEvent {
  final int height;
  const UpdateHeightEvent(this.height);

  @override
  List<Object?> get props => [height];
}

/// Step 6: Fitness goal event
final class UpdateGoalEvent extends RegisterEvent {
  final String goal;
  const UpdateGoalEvent(this.goal);

  @override
  List<Object?> get props => [goal];
}

/// Step 7: Activity level event
final class UpdateActivityLevelEvent extends RegisterEvent {
  final String activityLevel;
  const UpdateActivityLevelEvent(this.activityLevel);

  @override
  List<Object?> get props => [activityLevel];
}

/// Final Submission: Trigger final API registration call
final class SubmitFinalRegistrationEvent extends RegisterEvent {
  const SubmitFinalRegistrationEvent();
}

/// Reset: Clears multi-step registration data back to initial
final class ResetRegistrationEvent extends RegisterEvent {
  const ResetRegistrationEvent();
}

// =============================================================================
// Social Authentication Events
// =============================================================================

/// Google Sign-In Event
final class SignInWithGoogleEvent extends RegisterEvent {
  const SignInWithGoogleEvent();
}
