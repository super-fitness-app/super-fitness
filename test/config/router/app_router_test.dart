import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_constants.dart';
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
import 'package:super_fitness/features/auth/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:super_fitness/features/main_layout/body_layout/cubit/main_layout_cubit.dart';

class _MockStorageService implements StorageService {
  final Map<String, String> data = {};

  @override
  Future<void> save(String key, String value) async => data[key] = value;

  @override
  Future<String> get(String key) async => data[key] ?? '';

  @override
  Future<void> delete(String key) async => data.remove(key);
}

class _MockSessionService implements SessionService {
  String currentToken = '';

  @override
  Future<void> saveTokens({
    required String token,
    String? refreshToken,
    bool rememberMe = true,
  }) async => currentToken = token;

  @override
  Future<String> getToken() async => currentToken;

  @override
  Future<void> clearSession() async => currentToken = '';

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
  Future<ApiResults<LoginEntity>> login(LoginParams params) async =>
      const FailureResponse(NetworkFailure(AppError.cancelled));

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterParams request) async =>
      const FailureResponse(NetworkFailure(AppError.cancelled));

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() async =>
      const FailureResponse(NetworkFailure(AppError.cancelled));

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithFacebook() async =>
      const FailureResponse(NetworkFailure(AppError.cancelled));
}

void main() {
  group('AppRouter Configuration & Redirect Guard Tests', () {
    late _MockStorageService storageService;
    late _MockSessionService sessionService;

    setUp(() {
      storageService = _MockStorageService();
      sessionService = _MockSessionService();

      if (getIt.isRegistered<StorageService>()) {
        getIt.unregister<StorageService>();
      }
      getIt.registerSingleton<StorageService>(storageService);

      if (getIt.isRegistered<SessionService>()) {
        getIt.unregister<SessionService>();
      }
      getIt.registerSingleton<SessionService>(sessionService);

      if (getIt.isRegistered<OnboardingCubit>()) {
        getIt.unregister<OnboardingCubit>();
      }
      getIt.registerFactory<OnboardingCubit>(
        () => OnboardingCubit(getIt<StorageService>()),
      );

      if (getIt.isRegistered<LoginCubit>()) {
        getIt.unregister<LoginCubit>();
      }
      getIt.registerFactory<LoginCubit>(
        () => LoginCubit(
          LoginUseCase(const _FakeAuthRepo()),
          getIt<SessionService>(),
          SignInWithGoogleUseCase(const _FakeAuthRepo()),
          SignInWithFacebookUseCase(const _FakeAuthRepo()),
          const PasswordGenerator(),
        ),
      );
    });

    tearDown(() {
      if (getIt.isRegistered<LoginCubit>()) {
        getIt.unregister<LoginCubit>();
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

    test('createRouter returns GoRouter with expected initialLocation', () {
      final router = AppRouter.createRouter(
        storageService: storageService,
        sessionService: sessionService,
        initialLocation: AppRoutes.login,
      );

      expect(router, isNotNull);
      expect(
        router.routeInformationProvider.value.uri.path,
        equals(AppRoutes.login),
      );
    });

    test('router configuration contains all expected route paths', () {
      final router = AppRouter.createRouter(
        storageService: storageService,
        sessionService: sessionService,
        initialLocation: AppRoutes.login,
      );

      final routePaths = router.configuration.routes
          .whereType<GoRoute>()
          .map((r) => r.path)
          .toList();

      expect(
        routePaths,
        containsAll([
          AppRoutes.login,
          AppRoutes.onboarding,
          AppRoutes.register,
          AppRoutes.forgetPassword,
          AppRoutes.main,
        ]),
      );
    });

    testWidgets(
      'redirect sends first-time user to Onboarding when initialLocation is Login',
      (tester) async {
        final router = AppRouter.createRouter(
          storageService: storageService,
          sessionService: sessionService,
          initialLocation: AppRoutes.login,
        );

        await tester.pumpWidget(
          MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          router.routeInformationProvider.value.uri.path,
          equals(AppRoutes.onboarding),
        );
      },
    );

    testWidgets(
      'redirect sends unauthenticated user to Login when attempting to access Main',
      (tester) async {
        await storageService.save(AppConstants.hasSeenOnboardingKey, 'true');
        sessionService.currentToken = '';

        final router = AppRouter.createRouter(
          storageService: storageService,
          sessionService: sessionService,
          initialLocation: AppRoutes.main,
        );

        await tester.pumpWidget(
          MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          router.routeInformationProvider.value.uri.path,
          equals(AppRoutes.login),
        );
      },
    );

    testWidgets(
      'redirect sends returning user to Login when initialLocation is Onboarding',
      (tester) async {
        await storageService.save(AppConstants.hasSeenOnboardingKey, 'true');

        final router = AppRouter.createRouter(
          storageService: storageService,
          sessionService: sessionService,
          initialLocation: AppRoutes.onboarding,
        );

        await tester.pumpWidget(
          MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          router.routeInformationProvider.value.uri.path,
          equals(AppRoutes.login),
        );
      },
    );

    testWidgets(
      'redirect sends returning authenticated user directly to Main',
      (tester) async {
        await storageService.save(AppConstants.hasSeenOnboardingKey, 'true');
        sessionService.currentToken = 'valid_token';

        if (getIt.isRegistered<MainLayoutCubit>()) {
          getIt.unregister<MainLayoutCubit>();
        }
        getIt.registerFactory<MainLayoutCubit>(() => MainLayoutCubit());

        final router = AppRouter.createRouter(
          storageService: storageService,
          sessionService: sessionService,
          initialLocation: AppRoutes.login,
        );

        await tester.pumpWidget(
          MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        );
        await tester.pumpAndSettle();

        expect(
          router.routeInformationProvider.value.uri.path,
          equals(AppRoutes.main),
        );

        if (getIt.isRegistered<MainLayoutCubit>()) {
          getIt.unregister<MainLayoutCubit>();
        }
      },
    );
  });
}
