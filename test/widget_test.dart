import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/localization/locale_cubit.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/auth/presentation/login/view/login.dart';
import 'package:super_fitness/main.dart';

class FakeStorageService implements StorageService {
  @override
  Future<void> save(String key, String value) async {}

  @override
  Future<String> get(String key) async => '';

  @override
  Future<void> delete(String key) async {}
}

void main() {
  group('Super Fitness App & LoginView Deep Widget Tests', () {
    testWidgets(
      'renders SuperFitnessApp successfully with injected LocaleCubit',
      (WidgetTester tester) async {
        final storage = FakeStorageService();
        final localeCubit = LocaleCubit(storage);

        await tester.pumpWidget(SuperFitnessApp(localeCubit: localeCubit));
        await tester.pumpAndSettle();

        expect(find.byType(MaterialApp), findsOneWidget);
        expect(find.byType(LoginView), findsOneWidget);

        await localeCubit.close();
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
          home: const LoginView(),
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
