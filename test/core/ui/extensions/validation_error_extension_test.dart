import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/ui/extensions/validation_error_extension.dart';
import 'package:super_fitness/core/utils/app_validators.dart';

void main() {
  group('ValidationErrorLocalization Tests', () {
    testWidgets('maps every ValidationError to its localized message', (
      tester,
    ) async {
      late BuildContext buildContext;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              buildContext = context;
              return const SizedBox();
            },
          ),
        ),
      );

      for (final error in ValidationError.values) {
        final message = error.toLocalizedMessage(buildContext);
        expect(message, isNotEmpty);
      }

      expect(
        ValidationError.empty.toLocalizedMessage(buildContext),
        'This field is required',
      );
      expect(
        ValidationError.invalidEmail.toLocalizedMessage(buildContext),
        'Please enter a valid email address',
      );
    });
  });
}
