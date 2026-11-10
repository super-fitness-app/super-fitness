import 'dart:convert';

import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/core/utils/app_validators.dart';
import 'package:super_fitness/core/utils/password_generator.dart';
import 'package:super_fitness/features/auth/data/mapper/auth_mapper.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/use_cases/login_use_case.dart';
import 'package:super_fitness/features/auth/domain/use_cases/signin_with_facebook_usecase.dart';
import 'package:super_fitness/features/auth/domain/use_cases/signin_with_google_usecase.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_event.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_state.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState, BaseEvent> {
  final LoginUseCase _loginUseCase;
  final SessionService _sessionService;
  final SignInWithGoogleUseCase _signInWithGoogleUseCase;
  final SignInWithFacebookUseCase _signInWithFacebookUseCase;
  final PasswordGenerator _passwordGenerator;

  LoginCubit(
    this._loginUseCase,
    this._sessionService,
    this._signInWithGoogleUseCase,
    this._signInWithFacebookUseCase,
    this._passwordGenerator,
  ) : super(const LoginState());

  @override
  void doEvent(Object event) {
    switch (event) {
      case EmailChangedEvent(:final email):
        _onEmailChanged(email);
      case PasswordChangedEvent(:final password):
        _onPasswordChanged(password);
      case TogglePasswordVisibilityEvent():
        _onToggleVisibility();
      case SubmitLoginEvent():
        _onSubmit();
      case SignInWithGoogleEvent():
        _onSignInWithGoogle();
      case SignInWithFacebookEvent():
        _onSignInWithFacebook();
      default:
        break;
    }
  }

  void _onEmailChanged(String email) {
    emit(state.copyWith(email: email, emailError: null));
  }

  void _onPasswordChanged(String password) {
    emit(state.copyWith(password: password, passwordError: null));
  }

  void _onToggleVisibility() {
    emit(state.copyWith(isPasswordVisible: !state.isPasswordVisible));
  }

  Future<void> _onSubmit() async {
    final emailError = AppValidators.validateEmail(state.email);
    final passwordError = AppValidators.validateLoginPassword(state.password);

    if (emailError != null || passwordError != null) {
      emit(
        state.copyWith(emailError: emailError, passwordError: passwordError),
      );
      return;
    }

    emit(
      state.copyWith(
        loginApiState: BaseState.loading(),
        emailError: null,
        passwordError: null,
      ),
    );

    final result = await _loginUseCase(
      LoginParams(email: state.email.trim(), password: state.password),
    );

    _handleLoginResult(result);
  }

  Future<void> _handleLoginResult(ApiResults<LoginEntity> result) async {
    switch (result) {
      case Success<LoginEntity>(:final data):
        await _saveSessionAndNavigate(data);
      case FailureResponse<LoginEntity>(:final failure):
        emit(state.copyWith(loginApiState: BaseState.failure(failure)));
        emitEvent(DisplayError.fromFailure(failure));
    }
  }

  // ===========================================================================
  // Social Auth: Google & Facebook Sign-In
  // ===========================================================================

  Future<void> _onSignInWithGoogle() async {
    emit(state.copyWith(loginApiState: BaseState.loading()));

    final googleResult = await _signInWithGoogleUseCase();
    switch (googleResult) {
      case Success(:final data):
        await _handleSocialAuthUser(data, 'Google');
      case FailureResponse(:final failure):
        _handleSocialAuthFailure(failure);
    }
  }

  Future<void> _onSignInWithFacebook() async {
    emit(state.copyWith(loginApiState: BaseState.loading()));

    final facebookResult = await _signInWithFacebookUseCase();
    switch (facebookResult) {
      case Success(:final data):
        await _handleSocialAuthUser(data, 'Facebook');
      case FailureResponse(:final failure):
        _handleSocialAuthFailure(failure);
    }
  }

  Future<void> _handleSocialAuthUser(
    SocialAuthUserEntity data,
    String providerName,
  ) async {
    final userId = data.id;
    if (userId == null || userId.trim().isEmpty) {
      final errorMsg = '$providerName account ID is missing. Please try again.';
      emit(state.copyWith(loginApiState: BaseState.error(errorMsg)));
      emitEvent(DisplayError(errorMsg));
      return;
    }

    final generatedPassword = _passwordGenerator.generate(userId);
    final loginResult = await _loginUseCase(
      LoginParams(email: data.email, password: generatedPassword),
    );

    switch (loginResult) {
      case Success<LoginEntity>(:final data):
        await _saveSessionAndNavigate(data);
      case FailureResponse<LoginEntity>():
        const notFoundMsg = 'Account not found. Please register first.';
        emit(
          state.copyWith(
            loginApiState: BaseState.error(notFoundMsg),
          ),
        );
        emitEvent(const DisplayError(notFoundMsg));
    }
  }

  void _handleSocialAuthFailure(dynamic failure) {
    if (failure is CancelledFailure) {
      emit(state.copyWith(loginApiState: const BaseState.initial()));
      return;
    }
    emit(state.copyWith(loginApiState: BaseState.failure(failure)));
    emitEvent(DisplayError.fromFailure(failure));
  }

  Future<void> _saveSessionAndNavigate(LoginEntity data) async {
    await _sessionService.saveTokens(
      token: data.token,
      rememberMe: true,
    );
    await _sessionService.saveUserData(
      jsonEncode(AuthMapper.userEntityToJson(data.user)),
    );
    emit(state.copyWith(loginApiState: BaseState.success(data)));
    emitEvent(const NavigateEvent(AppRoutes.main));
  }

  Future<void> signInWithGoogleIntent() => _onSignInWithGoogle();
  Future<void> signInWithFacebookIntent() => _onSignInWithFacebook();
}
