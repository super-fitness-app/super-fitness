import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_images.dart';
import '../manager/register_cubit.dart';
import 'widgets/onboarding_bottom_button.dart';
import 'widgets/onboarding_scaffold.dart';
import 'widgets/onboarding_selectable_item.dart';

class SelectActivityView extends StatefulWidget {
  final VoidCallback? onBack;

  const SelectActivityView({
    super.key,
    this.onBack,
  });

  @override
  State<SelectActivityView> createState() => _SelectActivityViewState();
}

class _SelectActivityViewState extends State<SelectActivityView> {
  String? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = context.read<RegisterCubit>().state.data.activityLevel;
  }

  void _onSelect(String value) {
    setState(() => _selectedLevel = value);
  }

  void _onSubmit() {
    if (_selectedLevel == null) return;
    final cubit = context.read<RegisterCubit>();
    cubit.doEvent(UpdateActivityLevelEvent(_selectedLevel!));
    cubit.doEvent(const SubmitFinalRegistrationEvent());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final levels = [
      {'label': l10n.rookie, 'value': 'level1'},
      {'label': l10n.beginner, 'value': 'level2'},
      {'label': l10n.intermediate, 'value': 'level3'},
      {'label': l10n.advance, 'value': 'level4'},
      {'label': l10n.trueBeast, 'value': 'level5'},
    ];

    return OnboardingScaffold(
      onBackTap: widget.onBack,
      stepImage: AppImages.step6,
      title: l10n.activityLevelTitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: levels.map((item) {
          final value = item['value']!;
          return OnboardingSelectableItem(
            label: item['label']!,
            isSelected: _selectedLevel == value,
            onTap: () => _onSelect(value),
          );
        }).toList(),
      ),
      bottomButton: BlocBuilder<RegisterCubit, RegisterState>(
        builder: (context, state) {
          return OnboardingBottomButton(
            label: l10n.next,
            isEnabled: _selectedLevel != null,
            isLoading: state.isLoading,
            onPressed: _onSubmit,
          );
        },
      ),
    );
  }
}
