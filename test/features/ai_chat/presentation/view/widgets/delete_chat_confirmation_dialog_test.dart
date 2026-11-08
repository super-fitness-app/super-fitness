import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/delete_chat_confirmation_dialog.dart';

void main() {
  Widget buildTestHost({required ValueChanged<bool?> onResult}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () async {
                final result = await showDialog<bool>(
                  context: context,
                  builder: (_) => const DeleteChatConfirmationDialog(),
                );
                onResult(result);
              },
              child: const Text('Open Dialog'),
            );
          },
        ),
      ),
    );
  }

  group('DeleteChatConfirmationDialog Widget Tests', () {
    testWidgets('renders warning icon, title, message and buttons', (tester) async {
      await tester.pumpWidget(buildTestHost(onResult: (_) {}));
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.delete_forever_rounded), findsOneWidget);
      expect(find.text('Delete Conversation?'), findsOneWidget);
      expect(
        find.text(
          'Are you sure you want to delete this chat? This action cannot be undone.',
        ),
        findsOneWidget,
      );
      expect(find.text('Cancel'), findsOneWidget);
      expect(find.text('Delete'), findsOneWidget);
    });

    testWidgets('clicking Cancel pops dialog with false', (tester) async {
      bool? dialogResult;

      await tester.pumpWidget(
        buildTestHost(onResult: (result) => dialogResult = result),
      );
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(dialogResult, isFalse);
    });

    testWidgets('clicking Delete pops dialog with true', (tester) async {
      bool? dialogResult;

      await tester.pumpWidget(
        buildTestHost(onResult: (result) => dialogResult = result),
      );
      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();

      expect(dialogResult, isTrue);
    });
  });
}
