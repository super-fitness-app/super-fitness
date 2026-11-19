import 'package:equatable/equatable.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/change_password_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/edit_profile_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/logout_entity.dart';

class ProfileState extends Equatable {
  final UserEntity? user;

  final BaseState<EditProfileEntity> editProfileApiState;
  final BaseState<ChangePasswordEntity> changePasswordApiState;
  final BaseState<LogoutEntity> logoutApiState;

  final String? nameError;
  final String? phoneError;

  final String? currentPasswordError;
  final String? newPasswordError;
  final String? confirmPasswordError;

  final bool isCurrentPasswordVisible;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;

  const ProfileState({
    this.user,
    this.editProfileApiState = const BaseState.initial(),
    this.changePasswordApiState = const BaseState.initial(),
    this.logoutApiState = const BaseState.initial(),
    this.nameError,
    this.phoneError,
    this.currentPasswordError,
    this.newPasswordError,
    this.confirmPasswordError,
    this.isCurrentPasswordVisible = false,
    this.isNewPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
  });

  ProfileState copyWith({
    UserEntity? user,
    BaseState<EditProfileEntity>? editProfileApiState,
    BaseState<ChangePasswordEntity>? changePasswordApiState,
    BaseState<LogoutEntity>? logoutApiState,
    String? nameError,
    String? phoneError,
    String? currentPasswordError,
    String? newPasswordError,
    String? confirmPasswordError,
    bool? isCurrentPasswordVisible,
    bool? isNewPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return ProfileState(
      user: user ?? this.user,
      editProfileApiState: editProfileApiState ?? this.editProfileApiState,
      changePasswordApiState:
          changePasswordApiState ?? this.changePasswordApiState,
      logoutApiState: logoutApiState ?? this.logoutApiState,
      nameError: nameError ?? this.nameError,
      phoneError: phoneError ?? this.phoneError,
      currentPasswordError: currentPasswordError ?? this.currentPasswordError,
      newPasswordError: newPasswordError ?? this.newPasswordError,
      confirmPasswordError: confirmPasswordError ?? this.confirmPasswordError,
      isCurrentPasswordVisible:
          isCurrentPasswordVisible ?? this.isCurrentPasswordVisible,
      isNewPasswordVisible: isNewPasswordVisible ?? this.isNewPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }

  @override
  List<Object?> get props => [
    user,
    editProfileApiState,
    changePasswordApiState,
    logoutApiState,
    nameError,
    phoneError,
    currentPasswordError,
    newPasswordError,
    confirmPasswordError,
    isCurrentPasswordVisible,
    isNewPasswordVisible,
    isConfirmPasswordVisible,
  ];
}
