import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/popular_training_card_widget.dart';

void main() {
  Widget buildWidget({
    required String title,
    required String taskCountText,
    required String levelText,
    Color? levelColor,
    required String imageUrl,
    VoidCallback? onTap,
    double width = 280,
    double height = 195,
  }) {
    return MaterialApp(
      theme: AppTheme.darkTheme,
      home: Scaffold(
        body: Center(
          child: PopularTrainingCardWidget(
            title: title,
            taskCountText: taskCountText,
            levelText: levelText,
            levelColor: levelColor,
            imageUrl: imageUrl,
            onTap: onTap,
            width: width,
            height: height,
          ),
        ),
      ),
    );
  }

  group('PopularTrainingCardWidget Tests', () {
    testWidgets('renders all texts and badges properly', (tester) async {
      await tester.pumpWidget(
        buildWidget(
          title: 'Strengthen Your Chest',
          taskCountText: '24 Tasks',
          levelText: 'Beginner',
          levelColor: AppColors.primaryColor,
          imageUrl: 'https://example.com/chest.png',
        ),
      );
      await tester.pump();

      expect(find.text('Strengthen Your Chest'), findsOneWidget);
      expect(find.text('24 Tasks'), findsOneWidget);
      expect(find.text('Beginner'), findsOneWidget);
    });

    testWidgets('triggers onTap callback when tapped', (tester) async {
      bool tapped = false;

      await tester.pumpWidget(
        buildWidget(
          title: 'Back Power',
          taskCountText: '30 Tasks',
          levelText: 'Advanced',
          imageUrl: 'https://example.com/back.png',
          onTap: () {
            tapped = true;
          },
        ),
      );
      await tester.pump();

      await tester.tap(find.byType(PopularTrainingCardWidget));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}
