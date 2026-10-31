import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/core/utils/app_validators.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/use_cases/login_use_case.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_event.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_state.dart';

@injectable
class LoginCubit extends BaseCubit<LoginState, BaseEvent> {
  final LoginUseCase _loginUseCase;
  final SessionService _sessionService;

  LoginCubit(this._loginUseCase, this._sessionService)
    : super(const LoginState());

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
        await _sessionService.saveTokens(
          token: data.token,
          refreshToken: '',
          rememberMe: true,
        );
        emit(state.copyWith(loginApiState: BaseState.success(data)));
        emitEvent(const NavigateEvent(AppRoutes.main));
      case FailureResponse<LoginEntity>(:final failure):
        emit(state.copyWith(loginApiState: BaseState.failure(failure)));
        emitEvent(DisplayError.fromFailure(failure));
    }
  }
}
