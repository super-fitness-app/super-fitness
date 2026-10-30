import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_constants.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/cubit/onboarding_cubit.dart';

class _MockStorageService implements StorageService {
  final Map<String, String> data = {};

  @override
  Future<void> save(String key, String value) async {
    data[key] = value;
  }

  @override
  Future<String> get(String key) async => data[key] ?? '';

  @override
  Future<void> delete(String key) async {
    data.remove(key);
  }
}

void main() {
  group('AppRouter Configuration & Redirect Guard Tests', () {
    late _MockStorageService storageService;

    setUp(() {
      storageService = _MockStorageService();

      if (getIt.isRegistered<StorageService>()) {
        getIt.unregister<StorageService>();
      }
      getIt.registerSingleton<StorageService>(storageService);

      if (getIt.isRegistered<OnboardingCubit>()) {
        getIt.unregister<OnboardingCubit>();
      }
      getIt.registerFactory<OnboardingCubit>(
        () => OnboardingCubit(getIt<StorageService>()),
      );
    });

    tearDown(() {
      if (getIt.isRegistered<OnboardingCubit>()) {
        getIt.unregister<OnboardingCubit>();
      }
      if (getIt.isRegistered<StorageService>()) {
        getIt.unregister<StorageService>();
      }
    });

    test('createRouter returns GoRouter with expected initialLocation', () {
      final router = AppRouter.createRouter(
        storageService: storageService,
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
        initialLocation: AppRoutes.login,
      );

      final routePaths = router.configuration.routes
          .whereType<GoRoute>()
          .map((r) => r.path)
          .toList();

      expect(routePaths, containsAll([
        AppRoutes.login,
        AppRoutes.onboarding,
        AppRoutes.register,
        AppRoutes.forgetPassword,
        AppRoutes.main,
      ]));
    });

    testWidgets(
      'redirect sends first-time user to Onboarding when initialLocation is Login',
      (tester) async {
        final router = AppRouter.createRouter(
          storageService: storageService,
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
      'redirect sends returning user to Login when initialLocation is Onboarding',
      (tester) async {
        await storageService.save(AppConstants.hasSeenOnboardingKey, 'true');

        final router = AppRouter.createRouter(
          storageService: storageService,
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
      'redirect allows returning user directly to Login',
      (tester) async {
        await storageService.save(AppConstants.hasSeenOnboardingKey, 'true');

        final router = AppRouter.createRouter(
          storageService: storageService,
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
          equals(AppRoutes.login),
        );
      },
    );
  });
}
