import 'package:equatable/equatable.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/core/utils/app_validators.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';

class LoginState extends Equatable {
  final String email;
  final String password;
  final bool isPasswordVisible;
  final ValidationError? emailError;
  final ValidationError? passwordError;
  final BaseState<LoginEntity> loginApiState;

  const LoginState({
    this.email = '',
    this.password = '',
    this.isPasswordVisible = false,
    this.emailError,
    this.passwordError,
    this.loginApiState = const BaseState.initial(),
  });

  bool get isLoading => loginApiState.isLoading;

  LoginState copyWith({
    String? email,
    String? password,
    bool? isPasswordVisible,
    Object? emailError = unset,
    Object? passwordError = unset,
    BaseState<LoginEntity>? loginApiState,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      emailError: identical(emailError, unset)
          ? this.emailError
          : emailError as ValidationError?,
      passwordError: identical(passwordError, unset)
          ? this.passwordError
          : passwordError as ValidationError?,
      loginApiState: loginApiState ?? this.loginApiState,
    );
  }

  @override
  List<Object?> get props => [
    email,
    password,
    isPasswordVisible,
    emailError,
    passwordError,
    loginApiState,
  ];
}
