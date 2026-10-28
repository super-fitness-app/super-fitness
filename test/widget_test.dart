import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/core/localization/locale_cubit.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/auth/presentation/login/view/login.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/view/onboarding_view.dart';

import 'package:super_fitness/config/di/di.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_constants.dart';
import 'package:super_fitness/main.dart';

import 'package:super_fitness/features/auth/presentation/onboarding/cubit/onboarding_cubit.dart';

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

void main() {
  group('Super Fitness App & LoginView Deep Widget Tests', () {
    late FakeStorageService storage;
    late LocaleCubit localeCubit;

    setUp(() {
      storage = FakeStorageService();
      localeCubit = LocaleCubit(storage);

      if (getIt.isRegistered<StorageService>()) {
        getIt.unregister<StorageService>();
      }
      getIt.registerSingleton<StorageService>(storage);

      if (getIt.isRegistered<OnboardingCubit>()) {
        getIt.unregister<OnboardingCubit>();
      }
      getIt.registerFactory<OnboardingCubit>(
        () => OnboardingCubit(getIt<StorageService>()),
      );
    });

    tearDown(() async {
      await localeCubit.close();
      if (getIt.isRegistered<OnboardingCubit>()) {
        getIt.unregister<OnboardingCubit>();
      }
      if (getIt.isRegistered<StorageService>()) {
        getIt.unregister<StorageService>();
      }
    });

    testWidgets(
      'renders SuperFitnessApp and routes first-time user to OnboardingView',
      (WidgetTester tester) async {
        final router = AppRouter.createRouter(storageService: storage);

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
        final router = AppRouter.createRouter(storageService: storage);

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
            home: const LoginView(),
          ),
        );

        await tester.pumpAndSettle();

        // Verify Scaffold properties
        final scaffoldFinder = find.byType(Scaffold);
        expect(scaffoldFinder, findsOneWidget);
        final scaffold = tester.widget<Scaffold>(scaffoldFinder);
        expect(scaffold.backgroundColor, AppColors.background);

        // Verify SafeArea and Padding
        expect(find.byType(SafeArea), findsOneWidget);
        final paddingFinder = find.descendant(
          of: find.byType(SafeArea),
          matching: find.byType(Padding),
        );
        expect(paddingFinder, findsWidgets);

        // Verify localized title text and typography
        final titleFinder = find.text('Welcome Back!');
        expect(titleFinder, findsOneWidget);

        final textWidget = tester.widget<Text>(titleFinder);
        expect(textWidget.textAlign, TextAlign.center);
        expect(textWidget.style?.fontSize, AppTextStyles.appTitle.fontSize);
        expect(textWidget.style?.fontWeight, AppTextStyles.appTitle.fontWeight);
        expect(textWidget.style?.color, AppTextStyles.appTitle.color);
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
          home: const LoginView(),
        ),
      );

      await tester.pumpAndSettle();

      final l10n = await AppLocalizations.delegate.load(const Locale('ar'));
      final titleFinder = find.text(l10n.loginTitle);
      expect(titleFinder, findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}
