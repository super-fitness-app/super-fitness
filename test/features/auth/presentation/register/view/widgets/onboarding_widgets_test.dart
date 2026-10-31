import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/gender_option_button.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/horizontal_number_picker.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_bottom_button.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_header.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_scaffold.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_selectable_item.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_top_bar.dart';

void main() {
  group('GenderOptionButton Widget Tests', () {
    testWidgets('renders icon, label, and reflects selection style', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenderOptionButton(
              label: 'Male',
              icon: Icons.male,
              isSelected: true,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Male'), findsOneWidget);
      expect(find.byIcon(Icons.male), findsOneWidget);

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GenderOptionButton),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, AppColors.orangeBase);

      await tester.tap(find.byType(GenderOptionButton));
      expect(tapped, isTrue);
    });

    testWidgets('renders transparent background when unselected', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: GenderOptionButton(
              label: 'Female',
              icon: Icons.female,
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(GenderOptionButton),
          matching: find.byType(Container),
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      expect(decoration.color, Colors.transparent);
    });
  });

  group('HorizontalNumberPicker Widget Tests', () {
    testWidgets('renders unit label and handles page changes', (tester) async {
      int? changedValue;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalNumberPicker(
              minValue: 20,
              maxValue: 40,
              initialValue: 25,
              unitLabel: 'Year',
              onChanged: (val) => changedValue = val,
            ),
          ),
        ),
      );

      expect(find.text('Year'), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
      expect(find.byIcon(Icons.arrow_drop_up), findsOneWidget);

      // Drag PageView horizontally to change value
      await tester.drag(find.byType(PageView), const Offset(-100, 0));
      await tester.pumpAndSettle();

      expect(changedValue, isNotNull);
      expect(changedValue, greaterThan(20));
      expect(changedValue, lessThanOrEqualTo(40));
    });

    testWidgets('clamps initial value within min and max bounds', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: HorizontalNumberPicker(
              minValue: 10,
              maxValue: 30,
              initialValue: 5, // below min
              unitLabel: 'Kg',
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.text('Kg'), findsOneWidget);
      expect(find.text('10'), findsOneWidget);
    });
  });

  group('OnboardingSelectableItem Widget Tests', () {
    testWidgets('renders label and reflects selected styling', (tester) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingSelectableItem(
              label: 'Intermediate',
              isSelected: true,
              onTap: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Intermediate'), findsOneWidget);

      await tester.tap(find.byType(OnboardingSelectableItem));
      expect(tapped, isTrue);

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(OnboardingSelectableItem),
          matching: find.byType(Container).first,
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.color, AppColors.orangeBase);
    });

    testWidgets('renders unselected styling when isSelected is false', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingSelectableItem(
              label: 'Beginner',
              isSelected: false,
              onTap: () {},
            ),
          ),
        ),
      );

      final container = tester.widget<Container>(
        find.descendant(
          of: find.byType(OnboardingSelectableItem),
          matching: find.byType(Container).first,
        ),
      );
      final decoration = container.decoration as BoxDecoration;
      final border = decoration.border as Border;
      expect(border.top.color, Colors.white24);
    });
  });

  group('OnboardingBottomButton Widget Tests', () {
    testWidgets('renders label, invokes onPressed when enabled, and shows loading', (
      tester,
    ) async {
      var tapped = false;

      // 1. Enabled button
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingBottomButton(
              label: 'Continue',
              isEnabled: true,
              onPressed: () => tapped = true,
            ),
          ),
        ),
      );

      expect(find.text('Continue'), findsOneWidget);
      final elevatedButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(elevatedButton.onPressed, isNotNull);

      await tester.tap(find.byType(ElevatedButton));
      expect(tapped, isTrue);

      // 2. Disabled button
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingBottomButton(
              label: 'Continue',
              isEnabled: false,
              onPressed: () {},
            ),
          ),
        ),
      );
      final disabledButton = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
      expect(disabledButton.onPressed, isNull);

      // 3. Loading state
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingBottomButton(
              label: 'Continue',
              isLoading: true,
              onPressed: () {},
            ),
          ),
        ),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('OnboardingHeader & TopBar Widget Tests', () {
    testWidgets('OnboardingHeader renders step image, title, and optional subtitle', (
      tester,
    ) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: OnboardingHeader(
              stepImage: AppImages.step1,
              title: 'Tell us about yourself',
              subtitle: 'To give you a better experience',
            ),
          ),
        ),
      );

      expect(find.text('Tell us about yourself'), findsOneWidget);
      expect(find.text('To give you a better experience'), findsOneWidget);
      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('OnboardingTopBar renders logo and invokes onBackTap on back button', (
      tester,
    ) async {
      var backTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: OnboardingTopBar(
              onBackTap: () => backTapped = true,
            ),
          ),
        ),
      );

      expect(find.byType(Image), findsNWidgets(2));
      await tester.tap(find.byType(GestureDetector));
      expect(backTapped, isTrue);
    });
  });

  group('OnboardingScaffold Widget Tests', () {
    testWidgets('renders background, top bar, header, and wrapped content', (
      tester,
    ) async {
      var backTapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: OnboardingScaffold(
            stepImage: AppImages.step1,
            title: 'Test Step Title',
            subtitle: 'Test Step Subtitle',
            onBackTap: () => backTapped = true,
            content: const Text('Inner Content Widget'),
            bottomButton: const Text('Bottom Button Widget'),
          ),
        ),
      );

      expect(find.text('Test Step Title'), findsOneWidget);
      expect(find.text('Test Step Subtitle'), findsOneWidget);
      expect(find.text('Inner Content Widget'), findsOneWidget);
      expect(find.text('Bottom Button Widget'), findsOneWidget);

      await tester.tap(find.byType(GestureDetector).first);
      expect(backTapped, isTrue);
    });
  });
}

