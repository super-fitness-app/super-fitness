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
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';

import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/login_use_case.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:super_fitness/features/auth/presentation/login/view/login.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/forgot_password_button.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_card.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_footer.dart';
import 'package:super_fitness/features/auth/presentation/login/view/widgets/login_header_section.dart';

class _FakeAuthRepo implements AuthRepo {
  ApiResults<LoginEntity>? resultToReturn;
  Completer<ApiResults<LoginEntity>>? completer;

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
      throw UnimplementedError();
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
    late LoginCubit cubit;

    setUp(() {
      fakeAuthRepo = _FakeAuthRepo();
      fakeSessionService = _FakeSessionService();
      loginUseCase = LoginUseCase(fakeAuthRepo);
      cubit = LoginCubit(loginUseCase, fakeSessionService);
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

    testWidgets('renders all expected UI elements and excludes social logins', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      expect(find.byType(LoginHeaderSection), findsOneWidget);
      expect(find.byType(LoginCard), findsOneWidget);
      expect(find.byType(AppTextField), findsNWidgets(2));
      expect(find.byType(ForgotPasswordButton), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
      expect(find.byType(LoginFooter), findsOneWidget);

      expect(find.text('Or'), findsNothing);
      expect(find.text('Facebook'), findsNothing);
      expect(find.text('Google'), findsNothing);
      expect(find.text('Apple'), findsNothing);
    });

    testWidgets('toggles password visibility when eye icon tapped', (
      tester,
    ) async {
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

    testWidgets('submitting invalid form shows validation error messages', (
      tester,
    ) async {
      await tester.pumpWidget(createTestApp(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('loginSubmitButton')));
      await tester.pumpAndSettle();

      expect(cubit.state.emailError, isNotNull);
      expect(cubit.state.passwordError, isNotNull);
      expect(find.text('This field is required'), findsWidgets);
    });

    testWidgets(
      'entering invalid password displays localized error message in UI',
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
      },
    );

    testWidgets(
      'submitting valid credentials shows loading indicator and navigates on success',
      (tester) async {
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
            LoginEntity(message: 'OK', user: testUser, token: 'token_xyz'),
          ),
        );
        await tester.pumpAndSettle();

        expect(fakeSessionService.savedToken, 'token_xyz');
        expect(fakeSessionService.savedUserData, contains('test@example.com'));
        expect(find.text('Main'), findsOneWidget);
      },
    );
  });
}
