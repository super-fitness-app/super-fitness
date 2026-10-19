import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/core/ui/widgets/app_button.dart';

void main() {
  group('AppButton Widget Tests', () {
    testWidgets('renders button text and triggers tap when enabled', (
      tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Submit',
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Submit'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsNothing);

      await tester.tap(find.byType(AppButton));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets(
      'renders loading spinner and ignores tap when isLoading is true',
      (tester) async {
        var tapped = false;

        await tester.pumpWidget(
          MaterialApp(
            home: Scaffold(
              body: AppButton(
                text: 'Loading Button',
                isLoading: true,
                onPressed: () => tapped = true,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(find.text('Loading Button'), findsNothing);

        await tester.tap(find.byType(AppButton));
        await tester.pump();

        expect(tapped, isFalse);
      },
    );

    testWidgets('applies custom dimensions, styling, and background color', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Custom Style',
              width: 250,
              height: 56,
              backgroundColor: AppColors.error,
              textStyle: AppTextStyles.bold24,
              onPressed: () {},
            ),
          ),
        ),
      );

      final sizedBox = tester.widget<SizedBox>(
        find.descendant(
          of: find.byType(AppButton),
          matching: find.byType(SizedBox).first,
        ),
      );
      expect(sizedBox.width, 250);
      expect(sizedBox.height, 56);

      final text = tester.widget<Text>(find.text('Custom Style'));
      expect(text.style?.fontSize, 24);
    });

    testWidgets('renders disabled state when onPressed is null', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: AppButton(
              text: 'Disabled',
              onPressed: null,
            ),
          ),
        ),
      );

      final elevatedButton = tester.widget<ElevatedButton>(
        find.byType(ElevatedButton),
      );
      expect(elevatedButton.enabled, isFalse);
    });
  });
}
