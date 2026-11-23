import 'package:super_fitness/features/profile/domain/params/edit_profile_params.dart';

sealed class ProfileEvent {
  const ProfileEvent();
}

final class SubmitEditProfileEvent extends ProfileEvent {
  final EditProfileParams params;

  const SubmitEditProfileEvent(this.params);
}

final class GetUserDataEvent extends ProfileEvent {
  const GetUserDataEvent();
}

final class SubmitChangePasswordEvent extends ProfileEvent {
  final String password;
  final String newPassword;
  final String confirmPassword;

  const SubmitChangePasswordEvent({
    required this.password,
    required this.newPassword,
    required this.confirmPassword,
  });
}

final class LogoutEvent extends ProfileEvent {
  const LogoutEvent();
}

final class ToggleCurrentPasswordVisibilityEvent extends ProfileEvent {
  const ToggleCurrentPasswordVisibilityEvent();
}

final class ToggleNewPasswordVisibilityEvent extends ProfileEvent {
  const ToggleNewPasswordVisibilityEvent();
}

final class ToggleConfirmPasswordVisibilityEvent extends ProfileEvent {
  const ToggleConfirmPasswordVisibilityEvent();
}
