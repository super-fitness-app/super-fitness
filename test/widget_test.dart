import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/config/storage/storage_service.dart';

import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_constants.dart';
import 'package:super_fitness/core/localization/locale_cubit.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/core/utils/password_generator.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';

import 'package:super_fitness/features/auth/domain/use_cases/login_use_case.dart';
import 'package:super_fitness/features/auth/domain/use_cases/forget_password_usecase.dart';
import 'package:super_fitness/features/auth/domain/use_cases/verify_otp_usecase.dart';
import 'package:super_fitness/features/auth/domain/use_cases/reset_password_usecase.dart';

import 'package:super_fitness/features/auth/domain/use_cases/signin_with_facebook_usecase.dart';
import 'package:super_fitness/features/auth/domain/use_cases/signin_with_google_usecase.dart';
import 'package:super_fitness/features/auth/presentation/login/cubit/login_cubit.dart';
import 'package:super_fitness/features/auth/presentation/login/view/login.dart';

import 'package:super_fitness/features/auth/presentation/forget_password/manager/forget_password_cubit.dart';

import 'package:super_fitness/features/auth/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/view/onboarding_view.dart';

import 'package:super_fitness/main.dart';

class FakeStorageService implements StorageService {
  final Map<String, String> _data = {};

  @override
  Future<void> save(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<String> get(String key) async => _data[key] ?? '';

  @override
  Future<void> delete(String key) async {
    _data.remove(key);
  }
}

class FakeSessionService implements SessionService {
  String token = '';

  @override
  Future<void> saveTokens({
    required String token,
    String? refreshToken,
    bool rememberMe = true,
  }) async {
    this.token = token;
  }

  @override
  Future<String> getToken() async => token;

  @override
  Future<void> clearSession() async {
    token = '';
  }

  @override
  Future<String> getRefreshToken() async => '';

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
  Future<void> saveUserData(String userData) async {}

  @override
  Future<String> getUserData() async => '';
}

class _FakeAuthRepo implements AuthRepo {
  const _FakeAuthRepo();

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params) async {
    return const FailureResponse(NetworkFailure(AppError.cancelled));
  }

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterParams request) async {
    return const FailureResponse(NetworkFailure(AppError.cancelled));
  }

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() async {
    return const FailureResponse(NetworkFailure(AppError.cancelled));
  }

  @override
  Future<ApiResults<void>> forgotPassword({required String email}) async {
    return const FailureResponse(NetworkFailure(AppError.cancelled));
  }

  @override
  Future<ApiResults<Map<String, dynamic>>> verifyOtp({
    required String email,
    required String otp,
  }) async {
    return const FailureResponse(NetworkFailure(AppError.cancelled));
  }

  @override
  Future<ApiResults<void>> resetPassword({
    required String otpToken,
    required String password,
    required String confirmPassword,
  }) async {
    return const FailureResponse(NetworkFailure(AppError.cancelled));
  }

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithFacebook() async =>
      const FailureResponse(NetworkFailure(AppError.cancelled));
}

void main() {
  group('Super Fitness App & LoginView Deep Widget Tests', () {
    late FakeStorageService storage;
    late FakeSessionService sessionService;
    late LocaleCubit localeCubit;

    setUp(() {
      storage = FakeStorageService();
      sessionService = FakeSessionService();
      localeCubit = LocaleCubit(storage);

      const fakeAuthRepo = _FakeAuthRepo();

      // Storage Service
      if (getIt.isRegistered<StorageService>()) {
        getIt.unregister<StorageService>();
      }

      getIt.registerSingleton<StorageService>(storage);

      // Session Service
      if (getIt.isRegistered<SessionService>()) {
        getIt.unregister<SessionService>();
      }

      getIt.registerSingleton<SessionService>(sessionService);

      // Login Cubit
      if (getIt.isRegistered<LoginCubit>()) {
        getIt.unregister<LoginCubit>();
      }

      getIt.registerFactory<LoginCubit>(
        () => LoginCubit(
          LoginUseCase(fakeAuthRepo),
          getIt<SessionService>(),
          SignInWithGoogleUseCase(fakeAuthRepo),
          SignInWithFacebookUseCase(fakeAuthRepo),
          const PasswordGenerator(),
        ),
      );
      // Forget Password Cubit
      if (getIt.isRegistered<ForgetPasswordCubit>()) {
        getIt.unregister<ForgetPasswordCubit>();
      }

      getIt.registerFactory<ForgetPasswordCubit>(
        () => ForgetPasswordCubit(
          ForgetPasswordUseCase(fakeAuthRepo),
          VerifyOtpUseCase(fakeAuthRepo),
          ResetPasswordUseCase(fakeAuthRepo),
        ),
      );

      // Onboarding Cubit
      if (getIt.isRegistered<OnboardingCubit>()) {
        getIt.unregister<OnboardingCubit>();
      }

      getIt.registerFactory<OnboardingCubit>(
        () => OnboardingCubit(getIt<StorageService>()),
      );
    });

    tearDown(() async {
      await localeCubit.close();

      if (getIt.isRegistered<LoginCubit>()) {
        getIt.unregister<LoginCubit>();
      }

      if (getIt.isRegistered<ForgetPasswordCubit>()) {
        getIt.unregister<ForgetPasswordCubit>();
      }

      if (getIt.isRegistered<OnboardingCubit>()) {
        getIt.unregister<OnboardingCubit>();
      }

      if (getIt.isRegistered<SessionService>()) {
        getIt.unregister<SessionService>();
      }

      if (getIt.isRegistered<StorageService>()) {
        getIt.unregister<StorageService>();
      }
    });

    testWidgets(
      'renders SuperFitnessApp and routes first-time user to OnboardingView',
      (WidgetTester tester) async {
        final router = AppRouter.createRouter(
          storageService: storage,
          sessionService: sessionService,
        );

        await tester.pumpWidget(
          SuperFitnessApp(localeCubit: localeCubit, router: router),
        );

        await tester.pumpAndSettle();

        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.byType(OnboardingView), findsOneWidget);
      },
    );

    testWidgets(
      'renders SuperFitnessApp and routes returning user to LoginView',
      (WidgetTester tester) async {
        await storage.save(AppConstants.hasSeenOnboardingKey, 'true');

        final router = AppRouter.createRouter(
          storageService: storage,
          sessionService: sessionService,
        );

        await tester.pumpWidget(
          SuperFitnessApp(localeCubit: localeCubit, router: router),
        );

        await tester.pumpAndSettle();

        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.byType(LoginView), findsOneWidget);
      },
    );

    testWidgets(
      'LoginView renders with exact theme, styling, and text alignment',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.darkTheme,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: LoginView(cubit: getIt<LoginCubit>()),
          ),
        );

        await tester.pumpAndSettle();

        final scaffoldFinder = find.byType(Scaffold);

        expect(scaffoldFinder, findsOneWidget);

        final scaffold = tester.widget<Scaffold>(scaffoldFinder);

        expect(scaffold.backgroundColor, AppColors.background);
        expect(find.byType(SafeArea), findsOneWidget);

        expect(find.text('Hey There'), findsOneWidget);
        expect(find.text('WELCOME BACK'), findsOneWidget);
        expect(find.text('Login'), findsNWidgets(2));
      },
    );

    testWidgets('LoginView renders in Arabic locale (RTL) without overflow', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('ar'),
          home: LoginView(cubit: getIt<LoginCubit>()),
        ),
      );

      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('ar'));

      expect(find.text(l10n.welcomeBack), findsOneWidget);
      expect(find.text(l10n.login), findsNWidgets(2));
      expect(tester.takeException(), isNull);
    });
  });
}
