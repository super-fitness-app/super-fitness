import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/features/auth/presentation/register/view/register_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/already_have_account_row.dart';
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
      expect(find.text(AppStrings.heyThere), findsOneWidget);
      expect(find.text(AppStrings.createAnAccount), findsOneWidget);

      // Verify Form title
      expect(
        find.text(AppStrings.register),
        findsNWidgets(2),
      ); // Title & button

      // Verify 4 input fields
      expect(find.byType(RegisterTextField), findsNWidgets(4));
      expect(find.text(AppStrings.firstName), findsOneWidget);
      expect(find.text(AppStrings.lastName), findsOneWidget);
      expect(find.text(AppStrings.email), findsOneWidget);
      expect(find.text(AppStrings.password), findsOneWidget);

      // Verify Social auth buttons and Or divider
      expect(find.byType(SocialAuthButtons), findsOneWidget);
      expect(find.text(AppStrings.or), findsOneWidget);
      expect(find.byType(SocialIconButton), findsNWidgets(3));

      // Verify Register button
      expect(find.byType(ElevatedButton), findsOneWidget);

      // Verify already have account login link
      expect(find.byType(AlreadyHaveAccountRow), findsOneWidget);
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is RichText &&
              widget.text.toPlainText().contains(AppStrings.login),
        ),
        findsOneWidget,
      );
    });
  });
}
