import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/core/ui/widgets/app_button.dart';
import 'package:super_fitness/core/ui/widgets/app_text_field.dart';
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
import 'package:super_fitness/features/auth/presentation/login/view/login.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/forgot_password_button.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_card.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_footer.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_header_section.dart';
import 'package:super_fitness/features/auth/presentation/widgets/social_auth_buttons.dart';

class _FakeAuthRepo implements AuthRepo {
  ApiResults<LoginEntity>? resultToReturn;
  Completer<ApiResults<LoginEntity>>? completer;
  ApiResults<SocialAuthUserEntity>? googleResultToReturn;
  ApiResults<SocialAuthUserEntity>? facebookResultToReturn;

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params) async {
    if (completer != null) return completer!.future;
    return resultToReturn!;
  }

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterParams request) async =>
      throw UnimplementedError();

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() async =>
      googleResultToReturn!;

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithFacebook() async =>
      facebookResultToReturn!;
}

class _FakeSessionService implements SessionService {
  String? savedToken;
  String? savedUserData;

  @override
  Future<void> saveTokens({
    required String token,
    String? refreshToken,
    bool rememberMe = true,
  }) async {
    savedToken = token;
  }

  @override
  Future<void> clearSession() async {}
  @override
  Future<String> getRefreshToken() async => '';
  @override
  Future<String> getToken() async => savedToken ?? '';
  @override
  Future<bool> isGuest() async => false;
  @override
  Future<bool> isRemembered() async => true;
  @override
  Future<void> setGuestMode(bool value) async {}
  @override
  Future<void> setRememberMe(bool value) async {}
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
  group('LoginView Widget Tests', () {
    late _FakeAuthRepo fakeAuthRepo;
    late _FakeSessionService fakeSessionService;
    late LoginUseCase loginUseCase;
    late SignInWithGoogleUseCase signInWithGoogleUseCase;
    late SignInWithFacebookUseCase signInWithFacebookUseCase;
    const passwordGenerator = PasswordGenerator();
    late LoginCubit cubit;

    final testUser = UserEntity(
      id: 'u1',
      firstName: 'Test',
      lastName: 'User',
      email: 'test@example.com',
      gender: 'male',
      age: 25,
      weight: 70,
      height: 175,
      activityLevel: 'mid',
      goal: 'gain',
      photo: 'pic.png',
      createdAt: DateTime(2025, 1, 1),
    );

    setUp(() {
      fakeAuthRepo = _FakeAuthRepo();
      fakeSessionService = _FakeSessionService();
      loginUseCase = LoginUseCase(fakeAuthRepo);
      signInWithGoogleUseCase = SignInWithGoogleUseCase(fakeAuthRepo);
      signInWithFacebookUseCase = SignInWithFacebookUseCase(fakeAuthRepo);
      cubit = LoginCubit(
        loginUseCase,
        fakeSessionService,
        signInWithGoogleUseCase,
        signInWithFacebookUseCase,
        passwordGenerator,
      );
    });

    tearDown(() async {
      await cubit.close();
    });

    Widget createTestApp(LoginCubit cubit) {
      final router = GoRouter(
        initialLocation: AppRoutes.login,
        routes: [
          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) => BlocProvider<LoginCubit>.value(
              value: cubit,
              child: const LoginView(),
            ),
          ),
          GoRoute(
            path: AppRoutes.main,
            builder: (context, state) => const Scaffold(body: Text('Main')),
          ),
          GoRoute(
            path: AppRoutes.forgetPassword,
            builder: (context, state) =>
                const Scaffold(body: Text('ForgetPassword')),
          ),
          GoRoute(
            path: AppRoutes.register,
            builder: (context, state) => const Scaffold(body: Text('Register')),
          ),
        ],
      );

      return MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      );
    }

    testWidgets('renders all expected UI elements including social auth buttons',
        (tester) async {
      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      expect(find.byType(LoginHeaderSection), findsOneWidget);
      expect(find.byType(LoginCard), findsOneWidget);
      expect(find.byType(AppTextField), findsNWidgets(2));
      expect(find.byType(ForgotPasswordButton), findsOneWidget);
      expect(find.byType(SocialAuthButtons), findsOneWidget);
      expect(find.byKey(SocialAuthKeys.facebook), findsOneWidget);
      expect(find.byKey(SocialAuthKeys.google), findsOneWidget);
      expect(find.byKey(SocialAuthKeys.apple), findsOneWidget);
      expect(find.text('Or'), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
      expect(find.byType(LoginFooter), findsOneWidget);
    });

    testWidgets('toggles password visibility when eye icon tapped',
        (tester) async {
      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      final toggleFinder = find.byType(IconButton);
      expect(toggleFinder, findsOneWidget);

      await tester.tap(toggleFinder);
      await tester.pump();
      expect(cubit.state.isPasswordVisible, isTrue);

      await tester.tap(toggleFinder);
      await tester.pump();
      expect(cubit.state.isPasswordVisible, isFalse);
    });

    testWidgets('submitting invalid form shows validation error messages',
        (tester) async {
      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('loginSubmitButton')));
      await tester.pumpAndSettle();

      expect(cubit.state.emailError, isNotNull);
      expect(cubit.state.passwordError, isNotNull);
      expect(find.text('This field is required'), findsWidgets);
    });

    testWidgets('entering invalid password displays localized error message in UI',
        (tester) async {
      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('loginEmailField')),
        'user@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('loginPasswordField')),
        'short',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('loginSubmitButton')));
      await tester.pumpAndSettle();

      expect(cubit.state.passwordError, ValidationError.invalidLoginPassword);
      expect(
        find.text(
          'Password must be at least 6 characters with an uppercase letter and a number',
        ),
        findsOneWidget,
      );
    });

    testWidgets('submitting valid credentials shows loading indicator and navigates on success',
        (tester) async {
      final loginCompleter = Completer<ApiResults<LoginEntity>>();
      fakeAuthRepo.completer = loginCompleter;

      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      await tester.enterText(
        find.byKey(const Key('loginEmailField')),
        'test@example.com',
      );
      await tester.enterText(
        find.byKey(const Key('loginPasswordField')),
        'ValidPass1',
      );
      await tester.pump();

      await tester.tap(find.byKey(const Key('loginSubmitButton')));
      await tester.pump();

      // Loading indicator should appear on AppButton
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      loginCompleter.complete(
        Success<LoginEntity>(
          LoginEntity(
            message: 'OK',
            user: testUser,
            token: 'token_xyz',
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(fakeSessionService.savedToken, 'token_xyz');
      expect(fakeSessionService.savedUserData, contains('test@example.com'));
      expect(find.text('Main'), findsOneWidget);
    });

    testWidgets('tapping Google button signs in and navigates to Main when user is registered',
        (tester) async {
      fakeAuthRepo.googleResultToReturn = const Success(
        SocialAuthUserEntity(
          id: 'google-reg-1',
          email: 'reg@example.com',
          displayName: 'Reg User',
        ),
      );
      fakeAuthRepo.resultToReturn = Success<LoginEntity>(
        LoginEntity(message: 'OK', user: testUser, token: 'token_google_user'),
      );

      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(SocialAuthKeys.google));
      await tester.pumpAndSettle();

      expect(fakeSessionService.savedToken, 'token_google_user');
      expect(find.text('Main'), findsOneWidget);
    });

    testWidgets('tapping Google button shows notification to register first when user is not registered',
        (tester) async {
      fakeAuthRepo.googleResultToReturn = const Success(
        SocialAuthUserEntity(
          id: 'google-unreg-1',
          email: 'unreg@example.com',
          displayName: 'Unreg User',
        ),
      );
      fakeAuthRepo.resultToReturn = const FailureResponse<LoginEntity>(
        ServerMessageFailure('Invalid credentials'),
      );

      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(SocialAuthKeys.google));
      await tester.pumpAndSettle();

      expect(find.text('Account not found. Please register first.'), findsOneWidget);
      expect(fakeSessionService.savedToken, isNull);
    });

    testWidgets('tapping Facebook button signs in and navigates to Main when user is registered',
        (tester) async {
      fakeAuthRepo.facebookResultToReturn = const Success(
        SocialAuthUserEntity(
          id: 'fb-reg-1',
          email: 'fbreg@example.com',
          displayName: 'FB Reg User',
        ),
      );
      fakeAuthRepo.resultToReturn = Success<LoginEntity>(
        LoginEntity(message: 'OK', user: testUser, token: 'token_facebook_user'),
      );

      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(SocialAuthKeys.facebook));
      await tester.pumpAndSettle();

      expect(fakeSessionService.savedToken, 'token_facebook_user');
      expect(find.text('Main'), findsOneWidget);
    });

    testWidgets('tapping Facebook button shows notification to register first when user is not registered',
        (tester) async {
      fakeAuthRepo.facebookResultToReturn = const Success(
        SocialAuthUserEntity(
          id: 'fb-unreg-1',
          email: 'fbunreg@example.com',
          displayName: 'FB Unreg User',
        ),
      );
      fakeAuthRepo.resultToReturn = const FailureResponse<LoginEntity>(
        ServerMessageFailure('Invalid credentials'),
      );

      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(SocialAuthKeys.facebook));
      await tester.pumpAndSettle();

      expect(find.text('Account not found. Please register first.'), findsOneWidget);
      expect(fakeSessionService.savedToken, isNull);
    });
  });
}
