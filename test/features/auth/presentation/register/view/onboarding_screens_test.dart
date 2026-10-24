import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/features/auth/presentation/register/manager/register_cubit.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_activity_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_age_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_gender_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_goal_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_height_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/select_weight_view.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/gender_option_button.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/horizontal_number_picker.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_bottom_button.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_selectable_item.dart';

Widget _wrapWithCubit(Widget child, RegisterCubit cubit) {
  return MaterialApp(
    home: BlocProvider<RegisterCubit>.value(
      value: cubit,
      child: child,
    ),
  );
}

void main() {
  late RegisterCubit cubit;

  setUp(() {
    cubit = RegisterCubit();
  });

  tearDown(() {
    cubit.close();
  });

  group('SelectGenderView Widget Tests', () {
    testWidgets('renders all gender screen components correctly', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithCubit(const SelectGenderView(), cubit));

      expect(find.text(AppStrings.tellUsAboutYourself), findsOneWidget);
      expect(find.text(AppStrings.weNeedToKnowYourGender), findsOneWidget);
      expect(find.byType(GenderOptionButton), findsNWidgets(2));
      expect(find.text(AppStrings.male), findsOneWidget);
      expect(find.text(AppStrings.female), findsOneWidget);
      expect(find.byType(OnboardingBottomButton), findsOneWidget);
    });

    testWidgets('toggles gender selection and enables next button', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithCubit(const SelectGenderView(), cubit));

      final nextButton = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byType(OnboardingBottomButton),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(nextButton.onPressed, isNull);

      await tester.tap(find.text(AppStrings.male));
      await tester.pumpAndSettle();

      final enabledButton = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byType(OnboardingBottomButton),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(enabledButton.onPressed, isNotNull);
    });
  });

  group('SelectAgeView Widget Tests', () {
    testWidgets('renders age screen with horizontal picker', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithCubit(const SelectAgeView(), cubit));

      expect(find.text(AppStrings.howOldAreYou), findsOneWidget);
      expect(find.text(AppStrings.personalizedPlanSubtitle), findsOneWidget);
      expect(find.byType(HorizontalNumberPicker), findsOneWidget);
      expect(find.text(AppStrings.year), findsOneWidget);
    });
  });

  group('SelectWeightView Widget Tests', () {
    testWidgets('renders weight screen with horizontal picker and Done button', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithCubit(const SelectWeightView(), cubit));

      expect(find.text(AppStrings.whatIsYourWeight), findsOneWidget);
      expect(find.byType(HorizontalNumberPicker), findsOneWidget);
      expect(find.text(AppStrings.kg), findsOneWidget);
      expect(find.text(AppStrings.done), findsOneWidget);
    });
  });

  group('SelectHeightView Widget Tests', () {
    testWidgets('renders height screen with horizontal picker', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithCubit(const SelectHeightView(), cubit));

      expect(find.text(AppStrings.whatIsYourHeight), findsOneWidget);
      expect(find.byType(HorizontalNumberPicker), findsOneWidget);
      expect(find.text(AppStrings.cm), findsOneWidget);
      expect(find.text(AppStrings.next), findsOneWidget);
    });
  });

  group('SelectGoalView Widget Tests', () {
    testWidgets('renders all 5 goal options and enables button on selection', (
      tester,
    ) async {
      await tester.pumpWidget(_wrapWithCubit(const SelectGoalView(), cubit));

      expect(find.text(AppStrings.whatIsYourGoal), findsOneWidget);
      expect(find.byType(OnboardingSelectableItem), findsNWidgets(5));
      expect(find.text(AppStrings.gainWeight), findsOneWidget);
      expect(find.text(AppStrings.loseWeight), findsOneWidget);

      await tester.tap(find.text(AppStrings.getFitter));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byType(OnboardingBottomButton),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNotNull);
    });
  });

  group('SelectActivityView Widget Tests', () {
    testWidgets('renders all 5 activity level options and submits intent', (
      tester,
    ) async {
      await tester.pumpWidget(
        _wrapWithCubit(const SelectActivityView(), cubit),
      );

      expect(find.text(AppStrings.activityLevelTitle), findsOneWidget);
      expect(find.byType(OnboardingSelectableItem), findsNWidgets(5));
      expect(find.text(AppStrings.rookie), findsOneWidget);
      expect(find.text(AppStrings.beginner), findsOneWidget);
      expect(find.text(AppStrings.intermediate), findsOneWidget);
      expect(find.text(AppStrings.advance), findsOneWidget);
      expect(find.text(AppStrings.trueBeast), findsOneWidget);

      await tester.tap(find.text(AppStrings.intermediate));
      await tester.pumpAndSettle();

      final button = tester.widget<ElevatedButton>(
        find.descendant(
          of: find.byType(OnboardingBottomButton),
          matching: find.byType(ElevatedButton),
        ),
      );
      expect(button.onPressed, isNotNull);
    });
  });
}
