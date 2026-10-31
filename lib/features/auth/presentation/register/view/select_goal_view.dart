import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_images.dart';
import '../manager/register_cubit.dart';
import 'widgets/onboarding_bottom_button.dart';
import 'widgets/onboarding_scaffold.dart';
import 'widgets/onboarding_selectable_item.dart';

class SelectGoalView extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const SelectGoalView({
    super.key,
    this.onNext,
    this.onBack,
  });

  @override
  State<SelectGoalView> createState() => _SelectGoalViewState();
}

class _SelectGoalViewState extends State<SelectGoalView> {
  String? _selectedGoal;

  @override
  void initState() {
    super.initState();
    _selectedGoal = context.read<RegisterCubit>().state.data.goal;
  }

  void _onNext() {
    if (_selectedGoal == null) return;
    context.read<RegisterCubit>().doEvent(UpdateGoalEvent(_selectedGoal!));
    if (widget.onNext != null) {
      widget.onNext!();
    } else {
      context.push(AppRoutes.selectActivity);
    }
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
      onBackTap: widget.onBack,
      stepImage: AppImages.step5,
      title: l10n.whatIsYourGoal,
      subtitle: l10n.personalizedPlanSubtitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: goals.map((goal) {
          return OnboardingSelectableItem(
            label: goal,
            isSelected: _selectedGoal == goal,
            onTap: () => setState(() => _selectedGoal = goal),
          );
        }).toList(),
      ),
      bottomButton: OnboardingBottomButton(
        label: l10n.next,
        isEnabled: _selectedGoal != null,
        onPressed: _onNext,
      ),
    );
  }
}
