import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/core/utils/app_validators.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/login_use_case.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_event.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_state.dart';

class _FakeAuthRepo implements AuthRepo {
  ApiResults<LoginEntity>? resultToReturn;

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params) async {
    return resultToReturn!;
  }

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterParams request) async =>
      throw UnimplementedError();

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() async =>
      throw UnimplementedError();
}

class _FakeSessionService implements SessionService {
  String? savedToken;
  String? savedRefreshToken;
  bool? savedRememberMe;
  String? savedUserData;

  @override
  Future<void> saveTokens({
    required String token,
    String? refreshToken,
    bool rememberMe = true,
  }) async {
    savedToken = token;
    savedRefreshToken = refreshToken;
    savedRememberMe = rememberMe;
  }

  @override
  Future<void> clearSession() async {}

  @override
  Future<String> getRefreshToken() async => savedRefreshToken ?? '';

  @override
  Future<String> getToken() async => savedToken ?? '';

  @override
  Future<bool> isGuest() async => false;

  @override
  Future<bool> isRemembered() async => savedRememberMe ?? true;

  @override
  Future<void> setGuestMode(bool value) async {}

  @override
  Future<void> setRememberMe(bool value) async {
    savedRememberMe = value;
  }

  @override
  Future<void> updateTokens({
    required String token,
    required String refreshToken,
  }) async {}

  @override
  Future<void> saveUserData(String userData) async {
    savedUserData = userData;
  }

  @override
  Future<String> getUserData() async => savedUserData ?? '';
}

void main() {
  group('LoginCubit blocTest Suite', () {
    late _FakeAuthRepo fakeAuthRepo;
    late _FakeSessionService fakeSessionService;
    late LoginUseCase loginUseCase;

    final testUser = UserEntity(
      id: 'id1',
      firstName: 'Alex',
      lastName: 'Morgan',
      email: 'alex@example.com',
      gender: 'female',
      age: 26,
      weight: 65,
      height: 172,
      activityLevel: 'active',
      goal: 'strength',
      photo: 'pic.png',
      createdAt: DateTime(2025, 1, 1),
    );

    final testLoginEntity = LoginEntity(
      message: 'Logged in',
      user: testUser,
      token: 'jwt_token_alex',
    );

    setUp(() {
      fakeAuthRepo = _FakeAuthRepo();
      fakeSessionService = _FakeSessionService();
      loginUseCase = LoginUseCase(fakeAuthRepo);
    });

    test('initial state has default values', () {
      final cubit = LoginCubit(loginUseCase, fakeSessionService);
      expect(cubit.state, const LoginState());
      cubit.close();
    });

    blocTest<LoginCubit, LoginState>(
      'EmailChangedEvent updates email and clears email error',
      build: () => LoginCubit(loginUseCase, fakeSessionService),
      seed: () => const LoginState(emailError: ValidationError.invalidEmail),
      act: (cubit) => cubit.doEvent(const EmailChangedEvent('user@test.com')),
      expect: () => [
        const LoginState(email: 'user@test.com', emailError: null),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'PasswordChangedEvent updates password and clears password error',
      build: () => LoginCubit(loginUseCase, fakeSessionService),
      seed: () => const LoginState(
        passwordError: ValidationError.invalidLoginPassword,
      ),
      act: (cubit) =>
          cubit.doEvent(const PasswordChangedEvent('Password123')),
      expect: () => [
        const LoginState(password: 'Password123', passwordError: null),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'TogglePasswordVisibilityEvent flips password visibility correctly',
      build: () => LoginCubit(loginUseCase, fakeSessionService),
      act: (cubit) {
        cubit.doEvent(const TogglePasswordVisibilityEvent());
        cubit.doEvent(const TogglePasswordVisibilityEvent());
      },
      expect: () => [
        const LoginState(isPasswordVisible: true),
        const LoginState(isPasswordVisible: false),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'SubmitLoginEvent emits validation errors without calling use case when inputs invalid',
      build: () => LoginCubit(loginUseCase, fakeSessionService),
      seed: () => const LoginState(
        email: 'invalid-email',
        password: 'short',
      ),
      act: (cubit) => cubit.doEvent(const SubmitLoginEvent()),
      expect: () => [
        const LoginState(
          email: 'invalid-email',
          password: 'short',
          emailError: ValidationError.invalidEmail,
          passwordError: ValidationError.invalidLoginPassword,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'SubmitLoginEvent emits invalidLoginPassword when password is weak',
      build: () => LoginCubit(loginUseCase, fakeSessionService),
      seed: () => const LoginState(
        email: 'valid@example.com',
        password: 'invalid',
      ),
      act: (cubit) => cubit.doEvent(const SubmitLoginEvent()),
      expect: () => [
        const LoginState(
          email: 'valid@example.com',
          password: 'invalid',
          passwordError: ValidationError.invalidLoginPassword,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'SubmitLoginEvent emits loading then success, saves session and triggers navigation',
      build: () => LoginCubit(loginUseCase, fakeSessionService),
      setUp: () {
        fakeAuthRepo.resultToReturn = Success<LoginEntity>(testLoginEntity);
      },
      seed: () => const LoginState(
        email: 'alex@example.com',
        password: 'Password123',
      ),
      act: (cubit) => cubit.doEvent(const SubmitLoginEvent()),
      expect: () => [
        LoginState(
          email: 'alex@example.com',
          password: 'Password123',
          loginApiState: BaseState.loading(),
        ),
        LoginState(
          email: 'alex@example.com',
          password: 'Password123',
          loginApiState: BaseState.success(testLoginEntity),
        ),
      ],
      verify: (cubit) {
        expect(fakeSessionService.savedToken, 'jwt_token_alex');
        expect(fakeSessionService.savedUserData, contains('alex@example.com'));
      },
    );

    blocTest<LoginCubit, LoginState>(
      'SubmitLoginEvent emits loading then failure on server error',
      build: () => LoginCubit(loginUseCase, fakeSessionService),
      setUp: () {
        fakeAuthRepo.resultToReturn = const FailureResponse<LoginEntity>(
          ServerMessageFailure('Invalid credentials'),
        );
      },
      seed: () => const LoginState(
        email: 'alex@example.com',
        password: 'Password123',
      ),
      act: (cubit) => cubit.doEvent(const SubmitLoginEvent()),
      expect: () => [
        LoginState(
          email: 'alex@example.com',
          password: 'Password123',
          loginApiState: BaseState.loading(),
        ),
        LoginState(
          email: 'alex@example.com',
          password: 'Password123',
          loginApiState: BaseState.failure(
            const ServerMessageFailure('Invalid credentials'),
          ),
        ),
      ],
    );
  });
}
