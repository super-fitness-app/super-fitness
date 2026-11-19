import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_images.dart';

import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_bottom_button.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_scaffold.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_selectable_item.dart';

class EditProfileActivityView extends StatefulWidget {
  final String? initialLevel;

  const EditProfileActivityView({super.key, this.initialLevel});

  @override
  State<EditProfileActivityView> createState() =>
      _EditProfileActivityViewState();
}

class _EditProfileActivityViewState extends State<EditProfileActivityView> {
  String? _selectedLevel;

  @override
  void initState() {
    super.initState();
    _selectedLevel = widget.initialLevel;
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
      onBackTap: () => Navigator.of(context).pop(),
      stepImage: AppImages.step6,
      title: l10n.activityLevelTitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: levels.map((item) {
          final value = item['value']!;

          return OnboardingSelectableItem(
            label: item['label']!,
            isSelected: _selectedLevel == value,
            onTap: () {
              setState(() => _selectedLevel = value);
            },
          );
        }).toList(),
      ),
      bottomButton: OnboardingBottomButton(
        label: l10n.done,
        isEnabled: _selectedLevel != null,
        onPressed: () {
          Navigator.of(context).pop(_selectedLevel);
        },
      ),
    );
  }
}
