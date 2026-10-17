import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/features/splash/presentation/view/splash_view.dart';

void main() {
  group('SplashView Widget & Directionality Tests', () {
    testWidgets('renders properly in LTR (English)', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SplashView(),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('SUPER FITNESS'), findsOneWidget);
    });

    testWidgets('renders properly in RTL (Arabic) without overflow', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          locale: Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: SplashView(),
        ),
      );

      await tester.pumpAndSettle();
      expect(find.text('سوبر فيتنس'), findsOneWidget);
    });
  });
}
