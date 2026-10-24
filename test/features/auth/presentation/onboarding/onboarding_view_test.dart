import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_constants.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/view/onboarding_view.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/widgets/onboarding_background.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/widgets/onboarding_buttons.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/widgets/onboarding_character_section.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/widgets/onboarding_content.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/widgets/onboarding_indicator.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/widgets/onboarding_top_bar.dart';

class _MockStorageService implements StorageService {
  final Map<String, String> data = {};

  @override
  Future<void> save(String key, String value) async {
    data[key] = value;
  }

  @override
  Future<String> get(String key) async {
    return data[key] ?? '';
  }

  @override
  Future<void> delete(String key) async {
    data.remove(key);
  }
}

Widget _buildTestApp({
  required OnboardingCubit cubit,
  Locale locale = const Locale('en'),
  GoRouter? router,
}) {
  final testRouter =
      router ??
      GoRouter(
        initialLocation: AppRoutes.onboarding,
        routes: [
          GoRoute(
            path: AppRoutes.onboarding,
            builder: (context, state) => OnboardingView(cubit: cubit),
          ),
          GoRoute(
            path: AppRoutes.login,
            builder: (context, state) =>
                const Scaffold(body: Text('Login Screen Mock')),
          ),
        ],
      );

  return MaterialApp.router(
    theme: AppTheme.darkTheme,
    routerConfig: testRouter,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    locale: locale,
  );
}

void main() {
  group('OnboardingView MVI & Interaction Tests', () {
    late _MockStorageService storageService;
    late OnboardingCubit cubit;

    setUp(() {
      storageService = _MockStorageService();
      cubit = OnboardingCubit(storageService);

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

    tearDown(() async {
      await cubit.close();
      if (getIt.isRegistered<OnboardingCubit>()) {
        getIt.unregister<OnboardingCubit>();
      }
      if (getIt.isRegistered<StorageService>()) {
        getIt.unregister<StorageService>();
      }
    });

    testWidgets('renders extracted widgets and Page 1 initial state', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestApp(cubit: cubit));
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingView), findsOneWidget);
      expect(find.byType(OnboardingBackground), findsOneWidget);
      expect(find.byType(OnboardingCharacterSection), findsOneWidget);
      expect(find.byType(OnboardingTopBar), findsOneWidget);
      expect(find.byType(OnboardingContent), findsOneWidget);
      expect(find.byType(OnboardingIndicator), findsOneWidget);
      expect(find.byType(OnboardingButtons), findsOneWidget);

      expect(
        find.text('The Price Of Excellence\nIs Discipline'),
        findsOneWidget,
      );
      expect(find.text('Next'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
      expect(find.text('Back'), findsNothing);
    });

    testWidgets('tapping Next dispatches PageChangedIntent to Page 2', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestApp(cubit: cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(cubit.state.data, equals(1));
      expect(find.text('Fitness Has Never Been So\nMuch Fun'), findsOneWidget);
      expect(find.text('Back'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('tapping Back from Page 2 returns to Page 1', (tester) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestApp(cubit: cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Back'));
      await tester.pumpAndSettle();

      expect(cubit.state.data, equals(0));
      expect(
        find.text('The Price Of Excellence\nIs Discipline'),
        findsOneWidget,
      );
      expect(find.text('Back'), findsNothing);
    });

    testWidgets('finishing onboarding persists storage flag and navigates', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestApp(cubit: cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();

      expect(find.text('Do IT'), findsOneWidget);

      await tester.tap(find.text('Do IT'));
      await tester.pumpAndSettle();

      final hasSeen = await storageService.get(
        AppConstants.hasSeenOnboardingKey,
      );
      expect(hasSeen, equals('true'));
      expect(find.text('Login Screen Mock'), findsOneWidget);
    });

    testWidgets('skipping onboarding persists storage flag and navigates', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(_buildTestApp(cubit: cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      final hasSeen = await storageService.get(
        AppConstants.hasSeenOnboardingKey,
      );
      expect(hasSeen, equals('true'));
      expect(find.text('Login Screen Mock'), findsOneWidget);
    });

    testWidgets('router guard redirects first-time user to Onboarding', (
      tester,
    ) async {
      final freshStorage = _MockStorageService();
      final guardedRouter = AppRouter.createRouter(
        storageService: freshStorage,
        initialLocation: AppRoutes.login,
      );

      await tester.pumpWidget(
        MaterialApp.router(
          theme: AppTheme.darkTheme,
          routerConfig: guardedRouter,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingView), findsOneWidget);
    });

    testWidgets('router guard allows returning user directly to Login', (
      tester,
    ) async {
      final returningStorage = _MockStorageService();
      await returningStorage.save(AppConstants.hasSeenOnboardingKey, 'true');

      final guardedRouter = AppRouter.createRouter(
        storageService: returningStorage,
        initialLocation: AppRoutes.login,
      );

      await tester.pumpWidget(
        MaterialApp.router(
          theme: AppTheme.darkTheme,
          routerConfig: guardedRouter,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(OnboardingView), findsNothing);
    });

    testWidgets('Skip button is hidden on the final page slide', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(cubit: cubit));
      await tester.pumpAndSettle();

      expect(find.text('Skip'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Skip'), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(find.text('Skip'), findsNothing);
      expect(find.text('Do IT'), findsOneWidget);
    });

    testWidgets('renders correct character image per page index', (
      tester,
    ) async {
      await tester.pumpWidget(_buildTestApp(cubit: cubit));
      await tester.pumpAndSettle();

      Finder findImage(String assetName) => find.byWidgetPredicate(
        (w) =>
            w is Image &&
            w.image is AssetImage &&
            (w.image as AssetImage).assetName == assetName,
      );

      expect(findImage(AppImages.onboarding1), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(findImage(AppImages.onboarding2), findsOneWidget);

      await tester.tap(find.text('Next'));
      await tester.pumpAndSettle();
      expect(findImage(AppImages.onboarding3), findsOneWidget);
    });

    testWidgets('renders Arabic (RTL) localized content without overflow', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 2.0;
      addTearDown(() => tester.view.resetPhysicalSize());

      await tester.pumpWidget(
        _buildTestApp(cubit: cubit, locale: const Locale('ar')),
      );
      await tester.pumpAndSettle();

      expect(find.text('ثمن التميز\nهو الانضباط'), findsOneWidget);
      expect(find.text('التالي'), findsOneWidget);
      expect(find.text('تخطي'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
