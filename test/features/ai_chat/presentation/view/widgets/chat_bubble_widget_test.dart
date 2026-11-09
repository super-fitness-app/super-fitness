import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/chat_bubble_widget.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/coach_robot_avatar.dart';

void main() {
  group('ChatBubbleWidget Tests', () {
    testWidgets('renders CoachRobotAvatar for assistant messages', (tester) async {
      final msg = ChatMessageEntity(
        id: '1',
        role: 'assistant',
        content: 'I am your smart coach',
        timestamp: DateTime(2026),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatBubbleWidget(message: msg),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CoachRobotAvatar), findsOneWidget);
      expect(find.text('I am your smart coach'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsNothing);
    });

    testWidgets('renders person icon and hides CoachRobotAvatar for user messages',
        (tester) async {
      final msg = ChatMessageEntity(
        id: '2',
        role: 'user',
        content: 'Hello Coach',
        timestamp: DateTime(2026),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ChatBubbleWidget(message: msg),
          ),
        ),
      );
      await tester.pump();

      expect(find.byType(CoachRobotAvatar), findsNothing);
      expect(find.text('Hello Coach'), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}
