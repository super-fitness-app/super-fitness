import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_images.dart';

import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_bottom_button.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_scaffold.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_selectable_item.dart';

class EditProfileGoalView extends StatefulWidget {
  final String? initialGoal;

  const EditProfileGoalView({super.key, this.initialGoal});

  @override
  State<EditProfileGoalView> createState() => _EditProfileGoalViewState();
}

class _EditProfileGoalViewState extends State<EditProfileGoalView> {
  String? _selectedGoal;

  @override
  void initState() {
    super.initState();
    _selectedGoal = widget.initialGoal;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    final goals = [
      l10n.gainWeight,
      l10n.loseWeight,
      l10n.getFitter,
      l10n.gainMoreFlexible,
      l10n.learnTheBasic,
    ];

    return OnboardingScaffold(
      onBackTap: () => Navigator.of(context).pop(),
      stepImage: AppImages.step5,
      title: l10n.whatIsYourGoal,
      subtitle: l10n.personalizedPlanSubtitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: goals.map((goal) {
          return OnboardingSelectableItem(
            label: goal,
            isSelected: _selectedGoal == goal,
            onTap: () {
              setState(() => _selectedGoal = goal);
            },
          );
        }).toList(),
      ),
      bottomButton: OnboardingBottomButton(
        label: l10n.done,
        isEnabled: _selectedGoal != null,
        onPressed: () {
          Navigator.of(context).pop(_selectedGoal);
        },
      ),
    );
  }
}
