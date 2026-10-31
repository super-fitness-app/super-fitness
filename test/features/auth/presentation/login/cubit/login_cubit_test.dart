import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/core/utils/app_validators.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/login_use_case.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_event.dart';

class _FakeAuthRepo implements AuthRepo {
  ApiResults<LoginEntity>? resultToReturn;

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params) async {
    return resultToReturn!;
  }
}

class _FakeSessionService implements SessionService {
  String? savedToken;
  String? savedRefreshToken;
  bool? savedRememberMe;

  @override
  Future<void> saveTokens({
    required String token,
    required String refreshToken,
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
}

void main() {
  group('LoginCubit', () {
    late _FakeAuthRepo fakeAuthRepo;
    late _FakeSessionService fakeSessionService;
    late LoginUseCase loginUseCase;
    late LoginCubit cubit;

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
      cubit = LoginCubit(loginUseCase, fakeSessionService);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('initial state has default values', () {
      expect(cubit.state.email, '');
      expect(cubit.state.password, '');
      expect(cubit.state.isPasswordVisible, false);
      expect(cubit.state.emailError, isNull);
      expect(cubit.state.passwordError, isNull);
      expect(cubit.state.isLoading, false);
    });

    test('EmailChangedEvent updates email and clears error', () {
      cubit.doEvent(const EmailChangedEvent('user@test.com'));
      expect(cubit.state.email, 'user@test.com');
      expect(cubit.state.emailError, isNull);
    });

    test('PasswordChangedEvent updates password and clears error', () {
      cubit.doEvent(const PasswordChangedEvent('Password123'));
      expect(cubit.state.password, 'Password123');
      expect(cubit.state.passwordError, isNull);
    });

    test('TogglePasswordVisibilityEvent flips visibility', () {
      cubit.doEvent(const TogglePasswordVisibilityEvent());
      expect(cubit.state.isPasswordVisible, true);

      cubit.doEvent(const TogglePasswordVisibilityEvent());
      expect(cubit.state.isPasswordVisible, false);
    });

    test('SubmitLoginEvent emits validation errors when inputs invalid',
        () async {
      cubit.doEvent(const EmailChangedEvent('invalid-email'));
      cubit.doEvent(const PasswordChangedEvent('short'));

      cubit.doEvent(const SubmitLoginEvent());
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.emailError, ValidationError.invalidEmail);
      expect(cubit.state.passwordError, ValidationError.invalidLoginPassword);
      expect(cubit.state.isLoading, false);
    });

    test('SubmitLoginEvent on success saves tokens and emits NavigateEvent',
        () async {
      fakeAuthRepo.resultToReturn = Success<LoginEntity>(testLoginEntity);

      final events = <BaseEvent>[];
      final sub = cubit.eventStream.listen(events.add);

      cubit.doEvent(const EmailChangedEvent('alex@example.com'));
      cubit.doEvent(const PasswordChangedEvent('Password123'));

      cubit.doEvent(const SubmitLoginEvent());
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.loginApiState.data, testLoginEntity);
      expect(fakeSessionService.savedToken, 'jwt_token_alex');
      expect(events.length, 1);
      expect(events.first, isA<NavigateEvent>());
      expect((events.first as NavigateEvent).routeName, AppRoutes.main);

      await sub.cancel();
    });

    test('SubmitLoginEvent on failure emits DisplayError and failure state',
        () async {
      fakeAuthRepo.resultToReturn = const FailureResponse<LoginEntity>(
        ServerMessageFailure('Invalid credentials'),
      );

      final events = <BaseEvent>[];
      final sub = cubit.eventStream.listen(events.add);

      cubit.doEvent(const EmailChangedEvent('alex@example.com'));
      cubit.doEvent(const PasswordChangedEvent('Password123'));

      cubit.doEvent(const SubmitLoginEvent());
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state.loginApiState.failure, isNotNull);
      expect(events.length, 1);
      expect(events.first, isA<DisplayError>());

      await sub.cancel();
    });
  });
}
