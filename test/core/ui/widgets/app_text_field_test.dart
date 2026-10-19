import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/ui/widgets/app_text_field.dart';
import 'package:super_fitness/core/utils/app_validators.dart';

void main() {
  group('AppTextField Widget Tests', () {
    testWidgets('renders label, hint, and accepts input', (tester) async {
      final controller = TextEditingController();

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AppTextField(
              controller: controller,
              label: 'Email',
              hint: 'Enter your email',
            ),
          ),
        ),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Enter your email'), findsOneWidget);

      await tester.enterText(find.byType(TextFormField), 'test@example.com');
      expect(controller.text, 'test@example.com');
    });

    testWidgets('shows localized validation error on form validate', (
      tester,
    ) async {
      final formKey = GlobalKey<FormState>();

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: Form(
              key: formKey,
              child: AppTextField(
                label: 'Email',
                hint: 'Enter email',
                errorValidator: AppValidators.validateEmail,
              ),
            ),
          ),
        ),
      );

      formKey.currentState!.validate();
      await tester.pumpAndSettle();

      expect(find.text('This field is required'), findsOneWidget);
    });

    testWidgets('renders prefix and suffix icons with proper constraints', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'Password',
              hint: 'Enter password',
              prefixIcon: Icon(Icons.lock),
              suffixIcon: Icon(Icons.visibility),
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.lock), findsOneWidget);
      expect(find.byIcon(Icons.visibility), findsOneWidget);
    });

    testWidgets('respects obscureText, readOnly, and onChanged callback', (
      tester,
    ) async {
      var changedValue = '';

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'Secret',
              hint: 'Enter secret',
              obscureText: true,
              readOnly: false,
              onChanged: (val) => changedValue = val,
            ),
          ),
        ),
      );

      final editableText = tester.widget<EditableText>(
        find.byType(EditableText),
      );
      expect(editableText.obscureText, isTrue);
      expect(editableText.readOnly, isFalse);

      await tester.enterText(find.byType(TextFormField), 'mySecret');
      expect(changedValue, 'mySecret');
    });

    testWidgets('uses fallback label as hint when hint is empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppTextField(
              label: 'FallbackLabel',
              hint: '',
            ),
          ),
        ),
      );

      expect(find.text('FallbackLabel'), findsWidgets);
    });
  });
}
