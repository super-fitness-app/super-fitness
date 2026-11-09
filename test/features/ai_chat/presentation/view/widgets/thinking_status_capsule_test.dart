import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/thinking_status_capsule.dart';

void main() {
  group('ThinkingStatusCapsule Widget Tests', () {
    testWidgets('renders mini spinner and provided active status text', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ThinkingStatusCapsule(status: 'Analyzing workout split...'),
          ),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Analyzing workout split...'), findsOneWidget);
    });

    testWidgets('renders default fallback text when status is null or empty', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(body: ThinkingStatusCapsule(status: null)),
        ),
      );

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        find.text('Smart Coach is analyzing your fitness profile...'),
        findsOneWidget,
      );
    });
  });
}
