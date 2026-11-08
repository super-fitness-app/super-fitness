import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_bubble_widget.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_message_list_section.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/empty_chat_placeholder.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/thinking_status_capsule.dart';

Widget _buildTestableWidget({
  required List<ChatMessageEntity> messages,
  required bool isTyping,
  required bool isHistoryLoading,
  ValueChanged<String>? onPromptTap,
}) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(
      body: ChatMessageListSection(
        messages: messages,
        isTyping: isTyping,
        isHistoryLoading: isHistoryLoading,
        scrollController: ScrollController(),
        onPromptTap: onPromptTap ?? (_) {},
      ),
    ),
  );
}

void main() {
  group('ChatMessageListSection Widget Tests', () {
    testWidgets('renders CircularProgressIndicator when isHistoryLoading is true',
        (tester) async {
      await tester.pumpWidget(
        _buildTestableWidget(
          messages: const [],
          isTyping: false,
          isHistoryLoading: true,
        ),
      );
      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.byType(EmptyChatPlaceholder), findsNothing);
      expect(find.byType(ChatBubbleWidget), findsNothing);
    });

    testWidgets('renders EmptyChatPlaceholder when messages are empty and not loading',
        (tester) async {
      await tester.pumpWidget(
        _buildTestableWidget(
          messages: const [],
          isTyping: false,
          isHistoryLoading: false,
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(EmptyChatPlaceholder), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders ChatBubbleWidget when messages are present',
        (tester) async {
      final messages = [
        ChatMessageEntity(
          id: '1',
          role: 'user',
          content: 'Hello Coach',
          timestamp: DateTime(2026),
        ),
      ];

      await tester.pumpWidget(
        _buildTestableWidget(
          messages: messages,
          isTyping: false,
          isHistoryLoading: false,
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ChatBubbleWidget), findsOneWidget);
      expect(find.text('Hello Coach'), findsOneWidget);
      expect(find.byType(EmptyChatPlaceholder), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets('renders ThinkingStatusCapsule when isTyping is true',
        (tester) async {
      final messages = [
        ChatMessageEntity(
          id: '1',
          role: 'user',
          content: 'User message',
          timestamp: DateTime(2026),
        ),
      ];

      await tester.pumpWidget(
        _buildTestableWidget(
          messages: messages,
          isTyping: true,
          isHistoryLoading: false,
        ),
      );
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(ThinkingStatusCapsule), findsOneWidget);
    });
  });
}
