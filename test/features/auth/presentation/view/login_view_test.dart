import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/core/ui/widgets/app_button.dart';
import 'package:super_fitness/core/ui/widgets/app_text_field.dart';
import 'package:super_fitness/features/auth/presentation/view/login.dart';

void main() {
  setUpAll(() {
    GoogleFonts.config.allowRuntimeFetching = false;
  });

  group('LoginView Widget & Directionality Tests', () {
    testWidgets('renders properly in LTR (English) with elements', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LoginView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Welcome Back!'), findsOneWidget);
      expect(find.byType(AppTextField), findsNWidgets(2));
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);
      expect(find.byType(AppButton), findsOneWidget);
      expect(find.text('Login'), findsOneWidget);
    });

    testWidgets('renders properly in RTL (Arabic) without overflow', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LoginView(),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('مرحباً بعودتك!'), findsOneWidget);
      expect(find.byType(AppTextField), findsNWidgets(2));
      expect(find.byType(AppButton), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('allows user input in text fields and button interaction', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.darkTheme,
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LoginView(),
        ),
      );

      await tester.pumpAndSettle();

      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.at(0), 'user@superfitness.com');
      await tester.enterText(textFields.at(1), 'SecurePass123!');
      await tester.pump();

      expect(find.text('user@superfitness.com'), findsOneWidget);
      expect(find.text('SecurePass123!'), findsOneWidget);

      await tester.tap(find.byType(AppButton));
      await tester.pump();
      expect(tester.takeException(), isNull);
    });
  });
}
