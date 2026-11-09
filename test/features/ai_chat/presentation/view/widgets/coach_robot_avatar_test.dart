import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/coach_robot_avatar.dart';

void main() {
  group('CoachRobotAvatar Widget Tests', () {
    testWidgets('renders avatar with default size 36 and robot asset',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoachRobotAvatar(),
          ),
        ),
      );
      await tester.pump();

      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      final constraints = container.constraints;

      expect(constraints?.minWidth, equals(36));
      expect(constraints?.minHeight, equals(36));

      final imageFinder = find.byType(Image);
      expect(imageFinder, findsOneWidget);
      final image = tester.widget<Image>(imageFinder);
      expect((image.image as AssetImage).assetName, equals(AppImages.robot));
    });

    testWidgets('renders avatar with custom size 40 and correct decoration',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: CoachRobotAvatar(size: 40),
          ),
        ),
      );
      await tester.pump();

      final containerFinder = find.byType(Container).first;
      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration?;

      expect(decoration?.shape, equals(BoxShape.circle));
      expect(decoration?.color, equals(AppColors.surface));

      final constraints = container.constraints;
      expect(constraints?.minWidth, equals(40));
      expect(constraints?.minHeight, equals(40));
    });
  });
}
