import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/features/auth/presentation/register/view/register_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_header.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_text_field.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/social_auth_buttons.dart';

void main() {
  group('RegisterView Widget Tests', () {
    testWidgets('renders all register screen components correctly', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RegisterView(),
        ),
      );

      // Verify Header texts
      expect(find.byType(RegisterHeader), findsOneWidget);
      expect(find.text('Hey There'), findsOneWidget);
      expect(find.text('CREATE AN ACCOUNT'), findsOneWidget);

      // Verify Form title
      expect(find.text('Register'), findsNWidgets(2)); // Title & button

      // Verify 4 input fields
      expect(find.byType(RegisterTextField), findsNWidgets(4));
      expect(find.text('First Name'), findsOneWidget);
      expect(find.text('Last Name'), findsOneWidget);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Password'), findsOneWidget);

      // Verify Social auth buttons and Or divider
      expect(find.byType(SocialAuthButtons), findsOneWidget);
      expect(find.text('Or'), findsOneWidget);
      expect(find.byType(SocialIconButton), findsNWidgets(3));

      // Verify Register button
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Verify already have account login link
      expect(find.text('Already Have An Account ? Login', findRichText: true), findsOneWidget);
    });
  });
}
