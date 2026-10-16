import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/splash/presentation/view/splash_view.dart';

void main() {
  testWidgets('Super Fitness app smoke test renders SplashView with AppTheme', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.lightTheme,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const SplashView(),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.byType(SplashView), findsOneWidget);
  });
}
