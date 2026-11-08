import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/empty_chat_placeholder.dart';

void main() {
  Widget buildTestWidget({required ValueChanged<String> onPromptTap}) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: EmptyChatPlaceholder(onPromptTap: onPromptTap),
      ),
    );
  }

  group('EmptyChatPlaceholder Widget Tests', () {
    testWidgets('renders title, subtitle, and prompt chips', (tester) async {
      await tester.pumpWidget(buildTestWidget(onPromptTap: (_) {}));
      await tester.pumpAndSettle();

      expect(find.text('How can I help you today?'), findsOneWidget);
      expect(
        find.text(
          'Ask me about custom workout routines, diet macros, or form checks.',
        ),
        findsOneWidget,
      );
      expect(find.text('🏋️ Design a 3-day workout split'), findsOneWidget);
      expect(find.text('🥗 High protein meal ideas'), findsOneWidget);
      expect(find.text('🔥 How to fix my squat form?'), findsOneWidget);
    });

    testWidgets('tapping prompt chip invokes onPromptTap callback', (tester) async {
      String? selectedPrompt;

      await tester.pumpWidget(
        buildTestWidget(
          onPromptTap: (prompt) {
            selectedPrompt = prompt;
          },
        ),
      );
      await tester.pumpAndSettle();

      final firstChip = find.text('🏋️ Design a 3-day workout split');
      expect(firstChip, findsOneWidget);

      await tester.tap(firstChip);
      await tester.pumpAndSettle();

      expect(selectedPrompt, equals('🏋️ Design a 3-day workout split'));
    });
  });
}
