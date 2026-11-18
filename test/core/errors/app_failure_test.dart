import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/core/errors/app_failure.dart';

void main() {
  group('AppFailure Tests', () {
    test('value equality works for all AppFailure types', () {
      const n1 = NetworkFailure(AppError.noInternet);
      const n2 = NetworkFailure(AppError.noInternet);
      const n3 = NetworkFailure(AppError.timeout);
      expect(n1, equals(n2));
      expect(n1, isNot(equals(n3)));

      const s1 = ServerMessageFailure('Error');
      const s2 = ServerMessageFailure('Error');
      const s3 = ServerMessageFailure('Error 2');
      expect(s1, equals(s2));
      expect(s1, isNot(equals(s3)));

      const c1 = CancelledFailure('Cancelled');
      const c2 = CancelledFailure('Cancelled');
      const c3 = CancelledFailure('Different');
      expect(c1, equals(c2));
      expect(c1, isNot(equals(c3)));
    });

    testWidgets(
      'CancelledFailure returns custom message or localized fallback',
      (tester) async {
        late String customCancelledMsg;
        late String defaultCancelledMsg;

        await tester.pumpWidget(
          MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                const failure1 = CancelledFailure('User cancelled sign-in');
                const failure2 = CancelledFailure();
                customCancelledMsg = failure1.toLocalizedMessage(context);
                defaultCancelledMsg = failure2.toLocalizedMessage(context);
                return const SizedBox();
              },
            ),
          ),
        );

        expect(customCancelledMsg, 'User cancelled sign-in');
        expect(defaultCancelledMsg, isNotEmpty);
      },
    );

    testWidgets('ServerMessageFailure returns custom message directly', (
      tester,
    ) async {
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

    testWidgets('NetworkFailure returns localized message for AppError', (
      tester,
    ) async {
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
