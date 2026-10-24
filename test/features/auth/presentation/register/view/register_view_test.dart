import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:super_fitness/features/auth/presentation/register/view/register_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/already_have_account_row.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_header.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_password_field.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_text_field.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/social_auth_buttons.dart';

Widget _createTestWidget() {
  return const MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: RegisterView(),
  );
}

void main() {
  group('RegisterView Widget Tests', () {
    testWidgets('renders all register screen components correctly', (
      tester,
    ) async {
      await tester.pumpWidget(_createTestWidget());

      // Verify Header texts
      expect(find.byType(RegisterHeader), findsOneWidget);
      expect(find.text(AppStrings.heyThere), findsOneWidget);
      expect(find.text(AppStrings.createAnAccount), findsOneWidget);

      // Verify Form title & button
      expect(find.text(AppStrings.register), findsNWidgets(2));

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

    testWidgets('shows validation errors when Register is clicked with empty fields', (
      tester,
    ) async {
      await tester.pumpWidget(_createTestWidget());

      // Tap register button
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify error messages appear
      expect(find.text(AppStrings.firstNameRequired), findsOneWidget);
      expect(find.text(AppStrings.lastNameRequired), findsOneWidget);
      expect(find.text(AppStrings.invalidEmail), findsOneWidget);
      expect(find.text(AppStrings.passwordMinLength), findsOneWidget);
    });

    testWidgets('shows specific validation errors for invalid email and short password', (
      tester,
    ) async {
      await tester.pumpWidget(_createTestWidget());

      // Enter valid names but invalid email and short password
      await tester.enterText(find.byType(RegisterTextField).at(0), 'John');
      await tester.enterText(find.byType(RegisterTextField).at(1), 'Doe');
      await tester.enterText(
        find.byType(RegisterTextField).at(2),
        'invalid-email',
      );
      await tester.enterText(find.byType(RegisterTextField).at(3), 'short');

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.firstNameRequired), findsNothing);
      expect(find.text(AppStrings.lastNameRequired), findsNothing);
      expect(find.text(AppStrings.invalidEmail), findsOneWidget);
      expect(find.text(AppStrings.passwordMinLength), findsOneWidget);
    });

    testWidgets('clears validation errors when valid text is entered into all fields', (
      tester,
    ) async {
      await tester.pumpWidget(_createTestWidget());

      // Enter valid text in all 4 fields
      await tester.enterText(find.byType(RegisterTextField).at(0), 'John');
      await tester.enterText(find.byType(RegisterTextField).at(1), 'Doe');
      await tester.enterText(
        find.byType(RegisterTextField).at(2),
        'john.doe@example.com',
      );
      await tester.enterText(
        find.byType(RegisterTextField).at(3),
        'Password123!',
      );

      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.firstNameRequired), findsNothing);
      expect(find.text(AppStrings.lastNameRequired), findsNothing);
      expect(find.text(AppStrings.invalidEmail), findsNothing);
      expect(find.text(AppStrings.passwordMinLength), findsNothing);
    });

    testWidgets('toggles password visibility icon when suffix icon is tapped', (
      tester,
    ) async {
      await tester.pumpWidget(_createTestWidget());

      // Initially obscured with visibility_outlined
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);

      // Tap the password visibility toggle icon button
      final toggleButton = find.descendant(
        of: find.byType(RegisterPasswordField),
        matching: find.byType(IconButton),
      );
      await tester.tap(toggleButton);
      await tester.pumpAndSettle();

      // Obscure toggled off -> visibility_off_outlined is shown
      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsNothing);

      // Tap again to toggle back
      await tester.tap(toggleButton);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(find.byIcon(Icons.visibility_off_outlined), findsNothing);
    });

    testWidgets(
      'submits basic info intent and updates cubit state when form is valid',
      (tester) async {
        final testCubit = RegisterCubit();
        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: RegisterView(cubit: testCubit),
          ),
        );

        await tester.enterText(find.byType(RegisterTextField).at(0), 'John');
        await tester.enterText(find.byType(RegisterTextField).at(1), 'Doe');
        await tester.enterText(
          find.byType(RegisterTextField).at(2),
          'john.doe@example.com',
        );
        await tester.enterText(
          find.byType(RegisterTextField).at(3),
          'Password123!',
        );

        await tester.tap(find.byType(ElevatedButton));
        await tester.pumpAndSettle();

        expect(testCubit.state.data?.firstName, 'John');
        expect(testCubit.state.data?.lastName, 'Doe');
        expect(testCubit.state.data?.email, 'john.doe@example.com');
        expect(testCubit.state.data?.password, 'Password123!');
        expect(testCubit.state.data?.rePassword, 'Password123!');

        testCubit.close();
      },
    );
  });
}
