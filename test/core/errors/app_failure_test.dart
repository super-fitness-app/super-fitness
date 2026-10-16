import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/core/errors/app_failure.dart';
import 'package:super_fitness/core/ui/extensions/app_failure_extension.dart';

void main() {
  group('AppFailure & Localization Tests', () {
    testWidgets('ServerMessageFailure returns custom message directly', (tester) async {
      late String localizedMsg;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              const failure = ServerMessageFailure('Custom server error');
              localizedMsg = failure.toLocalizedMessage(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(localizedMsg, 'Custom server error');
    });

    testWidgets('NetworkFailure returns localized message for AppError', (tester) async {
      late String timeoutMsg;
      late String noConnectionMsg;

      await tester.pumpWidget(
        MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              const timeoutFailure = NetworkFailure(AppError.timeout);
              const noConnectionFailure = NetworkFailure(AppError.noConnection);
              timeoutMsg = timeoutFailure.toLocalizedMessage(context);
              noConnectionMsg = noConnectionFailure.toLocalizedMessage(context);
              return const SizedBox();
            },
          ),
        ),
      );

      expect(timeoutMsg, contains('Connection timed out'));
      expect(noConnectionMsg, contains('No internet connection'));
    });
  });
}
