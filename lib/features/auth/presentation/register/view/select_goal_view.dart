import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import '../manager/register_cubit.dart';
import 'widgets/onboarding_bottom_button.dart';
import 'widgets/onboarding_scaffold.dart';
import 'widgets/onboarding_selectable_item.dart';

class SelectGoalView extends StatefulWidget {
  const SelectGoalView({super.key});

  @override
  State<SelectGoalView> createState() => _SelectGoalViewState();
}

class _SelectGoalViewState extends State<SelectGoalView> {
  String? _selectedGoal;

  static const List<String> _goals = [
    AppStrings.gainWeight,
    AppStrings.loseWeight,
    AppStrings.getFitter,
    AppStrings.gainMoreFlexible,
    AppStrings.learnTheBasic,
  ];

  @override
  void initState() {
    super.initState();
    _selectedGoal = context.read<RegisterCubit>().state.data?.goal;
  }

  void _onNext() {
    if (_selectedGoal == null) return;
    context.read<RegisterCubit>().updateGoalIntent(_selectedGoal!);
    context.push(AppRoutes.selectActivity);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      stepImage: AppImages.step5,
      title: AppStrings.whatIsYourGoal,
      subtitle: AppStrings.personalizedPlanSubtitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: _goals.map((goal) {
          return OnboardingSelectableItem(
            label: goal,
            isSelected: _selectedGoal == goal,
            onTap: () => setState(() => _selectedGoal = goal),
          );
        }).toList(),
      ),
      bottomButton: OnboardingBottomButton(
        label: AppStrings.next,
        isEnabled: _selectedGoal != null,
        onPressed: _onNext,
      ),
    );
  }
}
