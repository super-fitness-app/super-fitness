import 'dart:convert';

import 'package:injectable/injectable.dart';

import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/features/auth/data/mapper/auth_mapper.dart';

import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_event.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_state.dart';

import 'package:super_fitness/features/profile/domain/entities/change_password_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/edit_profile_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/logout_entity.dart';

import 'package:super_fitness/features/profile/domain/params/change_password_params.dart';
import 'package:super_fitness/features/profile/domain/params/edit_profile_params.dart';

import 'package:super_fitness/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:super_fitness/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:super_fitness/features/profile/domain/use_cases/logout_use_case.dart';

@injectable
class ProfileCubit extends BaseCubit<ProfileState, BaseEvent> {
  final EditProfileUseCase? _editProfileUseCase;
  final ChangePasswordUseCase? _changePasswordUseCase;
  final LogoutUseCase? _logoutUseCase;
  final SessionService? _sessionService;

  ProfileCubit(
    this._editProfileUseCase,
    this._changePasswordUseCase,
    this._logoutUseCase,
    this._sessionService,
  ) : super(const ProfileState());

  ProfileCubit.dummy()
    : _editProfileUseCase = null,
      _changePasswordUseCase = null,
      _logoutUseCase = null,
      _sessionService = null,
      super(const ProfileState());

  @override
  void doEvent(Object event) {
    switch (event) {
      case GetUserDataEvent():
        _onGetUserData();

      case SubmitEditProfileEvent(:final params):
        _onEditProfile(params);

      case SubmitChangePasswordEvent(
        :final password,
        :final newPassword,
        :final confirmPassword,
      ):
        _onChangePassword(password, newPassword, confirmPassword);

      case LogoutEvent():
        _onLogout();

      case ToggleCurrentPasswordVisibilityEvent():
        _onToggleCurrentPasswordVisibility();

      case ToggleNewPasswordVisibilityEvent():
        _onToggleNewPasswordVisibility();

      case ToggleConfirmPasswordVisibilityEvent():
        _onToggleConfirmPasswordVisibility();

      default:
        break;
    }
  }

  // ===========================================================================
  // Get User Data
  // ===========================================================================

  Future<void> _onGetUserData() async {
    if (_sessionService == null) return;
    try {
      final userData = await _sessionService.getUserData();

      if (isClosed) return;

      final userJson = jsonDecode(userData);

      final user = AuthMapper.userEntityFromJson(userJson);

      emit(state.copyWith(user: user));
    } catch (e) {
      if (isClosed) return;

      emit(state.copyWith(user: null));

      emitEvent(const DisplayError('Unable to load user data.'));
    }
  }

  // ===========================================================================
  // Edit Profile
  // ===========================================================================

  Future<void> _onEditProfile(EditProfileParams params) async {
    if (_editProfileUseCase == null) return;
    emit(state.copyWith(editProfileApiState: BaseState.loading()));

    final result = await _editProfileUseCase(params);

    if (isClosed) return;

    switch (result) {
      case Success<EditProfileEntity>(:final data):
        emit(
          state.copyWith(
            user: data.user,
            editProfileApiState: BaseState.success(data),
          ),
        );

      case FailureResponse<EditProfileEntity>(:final failure):
        emit(state.copyWith(editProfileApiState: BaseState.failure(failure)));

        emitEvent(DisplayError.fromFailure(failure));
    }
  }

  // ===========================================================================
  // Change Password
  // ===========================================================================

  Future<void> _onChangePassword(
    String password,
    String newPassword,
    String confirmPassword,
  ) async {
    if (newPassword != confirmPassword) {
      const errorMessage = 'Passwords do not match.';

      emit(
        state.copyWith(changePasswordApiState: BaseState.error(errorMessage)),
      );

      emitEvent(const DisplayError(errorMessage));
      return;
    }

    emit(state.copyWith(changePasswordApiState: BaseState.loading()));

    if (_changePasswordUseCase == null) return;
    final result = await _changePasswordUseCase(
      ChangePasswordParams(password: password, newPassword: newPassword),
    );

    if (isClosed) return;

    switch (result) {
      case Success<ChangePasswordEntity>(:final data):
        emit(state.copyWith(changePasswordApiState: BaseState.success(data)));

      case FailureResponse<ChangePasswordEntity>(:final failure):
        emit(
          state.copyWith(changePasswordApiState: BaseState.failure(failure)),
        );

        emitEvent(DisplayError.fromFailure(failure));
    }
  }

  // ===========================================================================
  // Logout
  // ===========================================================================

  Future<void> _onLogout() async {
    emit(state.copyWith(logoutApiState: BaseState.loading()));

    if (_logoutUseCase == null) return;
    final result = await _logoutUseCase();

    if (isClosed) return;

    switch (result) {
      case Success<LogoutEntity>(:final data):
        await _sessionService?.clearSession();

        if (isClosed) return;

        emit(state.copyWith(logoutApiState: BaseState.success(data)));

        emitEvent(const NavigateEvent(AppRoutes.login));

      case FailureResponse<LogoutEntity>(:final failure):
        emit(state.copyWith(logoutApiState: BaseState.failure(failure)));

        emitEvent(DisplayError.fromFailure(failure));
    }
  }

  // ===========================================================================
  // Password Visibility
  // ===========================================================================

  void _onToggleCurrentPasswordVisibility() {
    emit(
      state.copyWith(isCurrentPasswordVisible: !state.isCurrentPasswordVisible),
    );
  }

  void _onToggleNewPasswordVisibility() {
    emit(state.copyWith(isNewPasswordVisible: !state.isNewPasswordVisible));
  }

  void _onToggleConfirmPasswordVisibility() {
    emit(
      state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible),
    );
  }
}
