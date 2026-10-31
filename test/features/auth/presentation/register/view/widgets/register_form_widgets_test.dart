import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_fields.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_form_card.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_header.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_password_field.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/register_text_field.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/social_auth_buttons.dart';

Widget _wrapWithLocalization(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: SingleChildScrollView(child: child),
    ),
  );
}

void main() {
  group('SocialAuthButtons & SocialIconButton Widget Tests', () {
    testWidgets(
      'renders OrDivider, three social buttons, and triggers all callbacks',
      (tester) async {
        var facebookTapped = false;
        var googleTapped = false;
        var appleTapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: SocialAuthButtons(
                onFacebookTap: () => facebookTapped = true,
                onGoogleTap: () => googleTapped = true,
                onAppleTap: () => appleTapped = true,
              ),
            ),
          ),
        );

        expect(find.byType(OrDivider), findsOneWidget);
        expect(find.text(AppStrings.or), findsOneWidget);
        expect(find.byType(SocialIconButton), findsNWidgets(3));

        // Tap Facebook
        await tester.tap(find.byType(SocialIconButton).at(0));
        expect(facebookTapped, isTrue);

        // Tap Google
        await tester.tap(find.byType(SocialIconButton).at(1));
        expect(googleTapped, isTrue);

        // Tap Apple
        await tester.tap(find.byType(SocialIconButton).at(2));
        expect(appleTapped, isTrue);
      },
    );

    testWidgets('SocialIconButton has circular shape and custom styling', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SocialIconButton(
              onTap: () {},
              child: const Icon(Icons.star),
            ),
          ),
        ),
      );

      final inkWellFinder = find.descendant(
        of: find.byType(SocialIconButton),
        matching: find.byType(InkWell),
      );
      expect(inkWellFinder, findsOneWidget);
      final inkWell = tester.widget<InkWell>(inkWellFinder);
      expect(inkWell.customBorder, isA<CircleBorder>());

      final inkFinder = find.descendant(
        of: find.byType(SocialIconButton),
        matching: find.byType(Ink),
      );
      expect(inkFinder, findsOneWidget);
      final ink = tester.widget<Ink>(inkFinder);
      expect(ink.decoration, isA<BoxDecoration>());
      final decoration = ink.decoration! as BoxDecoration;
      expect(decoration.shape, BoxShape.circle);
      expect(decoration.color, AppColors.socialButtonBackground);
      expect(find.byIcon(Icons.star), findsOneWidget);
    });
  });

  group('RegisterHeader Widget Tests', () {
    testWidgets('renders logo, title, and subtitle', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: RegisterHeader(),
          ),
        ),
      );

      expect(find.text(AppStrings.heyThere), findsOneWidget);
      expect(find.text(AppStrings.createAnAccount), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });
  });

  group('RegisterTextField & RegisterPasswordField Widget Tests', () {
    testWidgets('RegisterTextField binds controller and displays error on failed validation', (
      tester,
    ) async {
      final controller = TextEditingController();
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Form(
              key: formKey,
              child: RegisterTextField(
                controller: controller,
                hint: 'Enter name',
                prefixIcon: const Icon(Icons.person_outline),
                validator: (val) =>
                    (val == null || val.isEmpty) ? 'Name required' : null,
              ),
            ),
          ),
        ),
      );

      expect(find.text('Enter name'), findsOneWidget);
      expect(find.byIcon(Icons.person_outline), findsOneWidget);

      // Trigger validation with empty text
      formKey.currentState!.validate();
      await tester.pumpAndSettle();
      expect(find.text('Name required'), findsOneWidget);

      // Enter valid text
      await tester.enterText(find.byType(TextFormField), 'Alice');
      expect(controller.text, 'Alice');

      formKey.currentState!.validate();
      await tester.pumpAndSettle();
      expect(find.text('Name required'), findsNothing);

      controller.dispose();
    });

    testWidgets('RegisterPasswordField toggles obscureText and suffix icon on tap', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'secret123');

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RegisterPasswordField(
              controller: controller,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);

      // Initially password is obscured
      final editableTextFinder = find.byType(EditableText);
      expect(tester.widget<EditableText>(editableTextFinder).obscureText, isTrue);

      // Toggle to visible
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);
      expect(tester.widget<EditableText>(editableTextFinder).obscureText, isFalse);

      // Toggle back to obscured
      await tester.tap(find.byType(IconButton));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
      expect(tester.widget<EditableText>(editableTextFinder).obscureText, isTrue);

      controller.dispose();
    });
  });

  group('RegisterFields & RegisterFormCard Widget Tests', () {
    testWidgets('RegisterFields renders all four text input fields', (tester) async {
      final firstCtrl = TextEditingController();
      final lastCtrl = TextEditingController();
      final emailCtrl = TextEditingController();
      final passCtrl = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: RegisterFields(
                firstNameController: firstCtrl,
                lastNameController: lastCtrl,
                emailController: emailCtrl,
                passwordController: passCtrl,
              ),
            ),
          ),
        ),
      );

      expect(find.text(AppStrings.firstName), findsOneWidget);
      expect(find.text(AppStrings.lastName), findsOneWidget);
      expect(find.text(AppStrings.email), findsOneWidget);
      expect(find.text(AppStrings.password), findsOneWidget);

      firstCtrl.dispose();
      lastCtrl.dispose();
      emailCtrl.dispose();
      passCtrl.dispose();
    });

    testWidgets('RegisterFormCard renders title, fields, register button, and social buttons', (
      tester,
    ) async {
      final firstCtrl = TextEditingController();
      final lastCtrl = TextEditingController();
      final emailCtrl = TextEditingController();
      final passCtrl = TextEditingController();
      var registerPressed = false;
      var loginPressed = false;

      await tester.pumpWidget(
        _wrapWithLocalization(
          RegisterFormCard(
            firstNameController: firstCtrl,
            lastNameController: lastCtrl,
            emailController: emailCtrl,
            passwordController: passCtrl,
            isLoading: false,
            onRegisterPressed: () => registerPressed = true,
            onLoginTap: () => loginPressed = true,
          ),
        ),
      );

      expect(find.text(AppStrings.register), findsNWidgets(2)); // Title and Button
      expect(find.byType(RegisterFields), findsOneWidget);
      expect(find.byType(SocialAuthButtons), findsOneWidget);

      await tester.tap(find.byType(ElevatedButton));
      expect(registerPressed, isTrue);

      final richTextFinder = find.byType(RichText);
      final richText = tester.widget<RichText>(richTextFinder.first);
      final textSpan = richText.text as TextSpan;
      final loginSpan = textSpan.children!.first as TextSpan;
      (loginSpan.recognizer! as TapGestureRecognizer).onTap?.call();
      expect(loginPressed, isTrue);

      firstCtrl.dispose();
      lastCtrl.dispose();
      emailCtrl.dispose();
      passCtrl.dispose();
    });

    testWidgets('RegisterFormCard displays CircularProgressIndicator when isLoading is true', (
      tester,
    ) async {
      final firstCtrl = TextEditingController();
      final lastCtrl = TextEditingController();
      final emailCtrl = TextEditingController();
      final passCtrl = TextEditingController();

      await tester.pumpWidget(
        _wrapWithLocalization(
          RegisterFormCard(
            firstNameController: firstCtrl,
            lastNameController: lastCtrl,
            emailController: emailCtrl,
            passwordController: passCtrl,
            isLoading: true,
            onRegisterPressed: () {},
            onLoginTap: () {},
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      firstCtrl.dispose();
      lastCtrl.dispose();
      emailCtrl.dispose();
      passCtrl.dispose();
    });
  });
}
