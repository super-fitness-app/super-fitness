import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/core/utils/app_validators.dart';
import 'package:super_fitness/core/utils/password_generator.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/login_use_case.dart';
import 'package:super_fitness/features/auth/domain/use_cases/signin_with_facebook_usecase.dart';
import 'package:super_fitness/features/auth/domain/use_cases/signin_with_google_usecase.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_event.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_state.dart';

class _FakeAuthRepo implements AuthRepo {
  ApiResults<LoginEntity>? resultToReturn;
  ApiResults<SocialAuthUserEntity>? googleResultToReturn;
  ApiResults<SocialAuthUserEntity>? facebookResultToReturn;

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params) async {
    return resultToReturn!;
  }

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterParams request) async =>
      throw UnimplementedError();

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() async {
    return googleResultToReturn!;
  }

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithFacebook() async {
    return facebookResultToReturn!;
  }
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
    late SignInWithGoogleUseCase signInWithGoogleUseCase;
    late SignInWithFacebookUseCase signInWithFacebookUseCase;
    const passwordGenerator = PasswordGenerator();

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

    LoginCubit createCubit() => LoginCubit(
      loginUseCase,
      fakeSessionService,
      signInWithGoogleUseCase,
      signInWithFacebookUseCase,
      passwordGenerator,
    );

    setUp(() {
      fakeAuthRepo = _FakeAuthRepo();
      fakeSessionService = _FakeSessionService();
      loginUseCase = LoginUseCase(fakeAuthRepo);
      signInWithGoogleUseCase = SignInWithGoogleUseCase(fakeAuthRepo);
      signInWithFacebookUseCase = SignInWithFacebookUseCase(fakeAuthRepo);
    });

    test('initial state has default values', () {
      final cubit = createCubit();
      expect(cubit.state, const LoginState());
      cubit.close();
    });

    blocTest<LoginCubit, LoginState>(
      'EmailChangedEvent updates email and clears email error',
      build: createCubit,
      seed: () => const LoginState(emailError: ValidationError.invalidEmail),
      act: (cubit) => cubit.doEvent(const EmailChangedEvent('user@test.com')),
      expect: () => [
        const LoginState(email: 'user@test.com', emailError: null),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'PasswordChangedEvent updates password and clears password error',
      build: createCubit,
      seed: () =>
          const LoginState(passwordError: ValidationError.invalidLoginPassword),
      act: (cubit) => cubit.doEvent(const PasswordChangedEvent('Secret123')),
      expect: () => [
        const LoginState(password: 'Secret123', passwordError: null),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'TogglePasswordVisibilityEvent inverts isPasswordVisible',
      build: createCubit,
      act: (cubit) => cubit.doEvent(const TogglePasswordVisibilityEvent()),
      expect: () => [const LoginState(isPasswordVisible: true)],
    );

    blocTest<LoginCubit, LoginState>(
      'SubmitLoginEvent sets validation errors when fields invalid',
      build: createCubit,
      act: (cubit) => cubit.doEvent(const SubmitLoginEvent()),
      expect: () => [
        const LoginState(
          emailError: ValidationError.empty,
          passwordError: ValidationError.empty,
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'SubmitLoginEvent emits invalidLoginPassword when password is weak',
      build: createCubit,
      seed: () =>
          const LoginState(email: 'valid@example.com', password: 'invalid'),
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
      'SubmitLoginEvent emits loading then success on valid credentials',
      build: createCubit,
      setUp: () {
        fakeAuthRepo.resultToReturn = Success<LoginEntity>(testLoginEntity);
      },
      seed: () =>
          const LoginState(email: 'alex@example.com', password: 'Password123'),
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
      build: createCubit,
      setUp: () {
        fakeAuthRepo.resultToReturn = const FailureResponse<LoginEntity>(
          ServerMessageFailure('Invalid credentials'),
        );
      },
      seed: () =>
          const LoginState(email: 'alex@example.com', password: 'Password123'),
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

    // =========================================================================
    // Google Sign-In Tests
    // =========================================================================

    blocTest<LoginCubit, LoginState>(
      'SignInWithGoogleEvent logs in and navigates when user is already registered',
      build: createCubit,
      setUp: () {
        fakeAuthRepo.googleResultToReturn = const Success(
          SocialAuthUserEntity(
            id: 'google-user-123',
            email: 'googleuser@example.com',
            displayName: 'Google User',
            photoUrl: 'https://photo.url',
          ),
        );
        fakeAuthRepo.resultToReturn = Success<LoginEntity>(testLoginEntity);
      },
      act: (cubit) async {
        final events = <BaseEvent>[];
        final sub = cubit.eventStream.listen(events.add);
        await cubit.signInWithGoogleIntent();
        await pumpEventQueue();
        expect(events, contains(const NavigateEvent(AppRoutes.main)));
        await sub.cancel();
      },
      expect: () => [
        LoginState(loginApiState: BaseState.loading()),
        LoginState(loginApiState: BaseState.success(testLoginEntity)),
      ],
      verify: (_) {
        expect(fakeSessionService.savedToken, 'jwt_token_alex');
        expect(fakeSessionService.savedUserData, contains('alex@example.com'));
      },
    );

    blocTest<LoginCubit, LoginState>(
      'SignInWithGoogleEvent notifies user to register first when user is not registered',
      build: createCubit,
      setUp: () {
        fakeAuthRepo.googleResultToReturn = const Success(
          SocialAuthUserEntity(
            id: 'google-unregistered-id',
            email: 'unregistered@example.com',
            displayName: 'New Google User',
          ),
        );
        fakeAuthRepo.resultToReturn = const FailureResponse<LoginEntity>(
          ServerMessageFailure('Invalid credentials or user not found'),
        );
      },
      act: (cubit) async {
        final events = <BaseEvent>[];
        final sub = cubit.eventStream.listen(events.add);
        await cubit.signInWithGoogleIntent();
        await pumpEventQueue();
        expect(
          events.whereType<DisplayError>().map((e) => e.errorMsg),
          contains('Account not found. Please register first.'),
        );
        await sub.cancel();
      },
      expect: () => [
        LoginState(loginApiState: BaseState.loading()),
        LoginState(
          loginApiState: BaseState.error(
            'Account not found. Please register first.',
          ),
        ),
      ],
      verify: (_) {
        expect(fakeSessionService.savedToken, isNull);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'SignInWithGoogleEvent emits error when Google account ID is missing',
      build: createCubit,
      setUp: () {
        fakeAuthRepo.googleResultToReturn = const Success(
          SocialAuthUserEntity(
            id: null,
            email: 'missingid@example.com',
            displayName: 'No ID User',
          ),
        );
      },
      act: (cubit) async {
        final events = <BaseEvent>[];
        final sub = cubit.eventStream.listen(events.add);
        await cubit.signInWithGoogleIntent();
        await pumpEventQueue();
        expect(
          events.whereType<DisplayError>().map((e) => e.errorMsg),
          contains('Google account ID is missing. Please try again.'),
        );
        await sub.cancel();
      },
      expect: () => [
        LoginState(loginApiState: BaseState.loading()),
        LoginState(
          loginApiState: BaseState.error(
            'Google account ID is missing. Please try again.',
          ),
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'SignInWithGoogleEvent reverts to initial state silently when cancelled by user',
      build: createCubit,
      setUp: () {
        fakeAuthRepo.googleResultToReturn = const FailureResponse(
          CancelledFailure('User cancelled sign-in'),
        );
      },
      act: (cubit) async {
        final events = <BaseEvent>[];
        final sub = cubit.eventStream.listen(events.add);
        await cubit.signInWithGoogleIntent();
        expect(events, isEmpty);
        await sub.cancel();
      },
      expect: () => [
        LoginState(loginApiState: BaseState.loading()),
        const LoginState(loginApiState: BaseState.initial()),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'SignInWithGoogleEvent emits failure on Google sign-in failure',
      build: createCubit,
      setUp: () {
        fakeAuthRepo.googleResultToReturn = const FailureResponse(
          ServerMessageFailure('Google Sign-In failed'),
        );
      },
      act: (cubit) => cubit.signInWithGoogleIntent(),
      expect: () => [
        LoginState(loginApiState: BaseState.loading()),
        LoginState(
          loginApiState: BaseState.failure(
            const ServerMessageFailure('Google Sign-In failed'),
          ),
        ),
      ],
    );

    // =========================================================================
    // Facebook Sign-In Tests
    // =========================================================================

    blocTest<LoginCubit, LoginState>(
      'SignInWithFacebookEvent logs in and navigates when user is already registered',
      build: createCubit,
      setUp: () {
        fakeAuthRepo.facebookResultToReturn = const Success(
          SocialAuthUserEntity(
            id: 'facebook-user-123',
            email: 'facebookuser@example.com',
            displayName: 'Facebook User',
            photoUrl: 'https://photo.url',
          ),
        );
        fakeAuthRepo.resultToReturn = Success<LoginEntity>(testLoginEntity);
      },
      act: (cubit) async {
        final events = <BaseEvent>[];
        final sub = cubit.eventStream.listen(events.add);
        await cubit.signInWithFacebookIntent();
        await pumpEventQueue();
        expect(events, contains(const NavigateEvent(AppRoutes.main)));
        await sub.cancel();
      },
      expect: () => [
        LoginState(loginApiState: BaseState.loading()),
        LoginState(loginApiState: BaseState.success(testLoginEntity)),
      ],
      verify: (_) {
        expect(fakeSessionService.savedToken, 'jwt_token_alex');
        expect(fakeSessionService.savedUserData, contains('alex@example.com'));
      },
    );

    blocTest<LoginCubit, LoginState>(
      'SignInWithFacebookEvent notifies user to register first when user is not registered',
      build: createCubit,
      setUp: () {
        fakeAuthRepo.facebookResultToReturn = const Success(
          SocialAuthUserEntity(
            id: 'facebook-unregistered-id',
            email: 'unregistered@example.com',
            displayName: 'New Facebook User',
          ),
        );
        fakeAuthRepo.resultToReturn = const FailureResponse<LoginEntity>(
          ServerMessageFailure('Invalid credentials or user not found'),
        );
      },
      act: (cubit) async {
        final events = <BaseEvent>[];
        final sub = cubit.eventStream.listen(events.add);
        await cubit.signInWithFacebookIntent();
        await pumpEventQueue();
        expect(
          events.whereType<DisplayError>().map((e) => e.errorMsg),
          contains('Account not found. Please register first.'),
        );
        await sub.cancel();
      },
      expect: () => [
        LoginState(loginApiState: BaseState.loading()),
        LoginState(
          loginApiState: BaseState.error(
            'Account not found. Please register first.',
          ),
        ),
      ],
      verify: (_) {
        expect(fakeSessionService.savedToken, isNull);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'SignInWithFacebookEvent emits error when Facebook account ID is missing',
      build: createCubit,
      setUp: () {
        fakeAuthRepo.facebookResultToReturn = const Success(
          SocialAuthUserEntity(
            id: null,
            email: 'missingid@example.com',
            displayName: 'No ID User',
          ),
        );
      },
      act: (cubit) async {
        final events = <BaseEvent>[];
        final sub = cubit.eventStream.listen(events.add);
        await cubit.signInWithFacebookIntent();
        await pumpEventQueue();
        expect(
          events.whereType<DisplayError>().map((e) => e.errorMsg),
          contains('Facebook account ID is missing. Please try again.'),
        );
        await sub.cancel();
      },
      expect: () => [
        LoginState(loginApiState: BaseState.loading()),
        LoginState(
          loginApiState: BaseState.error(
            'Facebook account ID is missing. Please try again.',
          ),
        ),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'SignInWithFacebookEvent reverts to initial state silently when cancelled by user',
      build: createCubit,
      setUp: () {
        fakeAuthRepo.facebookResultToReturn = const FailureResponse(
          CancelledFailure('User cancelled sign-in'),
        );
      },
      act: (cubit) async {
        final events = <BaseEvent>[];
        final sub = cubit.eventStream.listen(events.add);
        await cubit.signInWithFacebookIntent();
        expect(events, isEmpty);
        await sub.cancel();
      },
      expect: () => [
        LoginState(loginApiState: BaseState.loading()),
        const LoginState(loginApiState: BaseState.initial()),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'SignInWithFacebookEvent emits failure on Facebook sign-in failure',
      build: createCubit,
      setUp: () {
        fakeAuthRepo.facebookResultToReturn = const FailureResponse(
          ServerMessageFailure('Facebook Sign-In failed'),
        );
      },
      act: (cubit) => cubit.signInWithFacebookIntent(),
      expect: () => [
        LoginState(loginApiState: BaseState.loading()),
        LoginState(
          loginApiState: BaseState.failure(
            const ServerMessageFailure('Facebook Sign-In failed'),
          ),
        ),
      ],
    );
  });
}
