import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_images.dart';

// Reuse the existing onboarding widgets.
import 'package:super_fitness/features/auth/presentation/register/view/widgets/horizontal_number_picker.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_bottom_button.dart';
import 'package:super_fitness/features/auth/presentation/register/view/widgets/onboarding_scaffold.dart';

class EditProfileWeightView extends StatefulWidget {
  final int initialWeight;

  const EditProfileWeightView({super.key, required this.initialWeight});

  @override
  State<EditProfileWeightView> createState() => _EditProfileWeightViewState();
}

class _EditProfileWeightViewState extends State<EditProfileWeightView> {
  late int _selectedWeight;

  @override
  void initState() {
    super.initState();
    _selectedWeight = widget.initialWeight;
  }

  void _onDone() {
    Navigator.of(context).pop(_selectedWeight);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OnboardingScaffold(
      onBackTap: () => Navigator.of(context).pop(),
      stepImage: AppImages.step3,
      title: l10n.whatIsYourWeight,
      subtitle: l10n.personalizedPlanSubtitle,
      content: HorizontalNumberPicker(
        minValue: 30,
        maxValue: 220,
        initialValue: _selectedWeight,
        unitLabel: l10n.kg,
        onChanged: (weight) {
          _selectedWeight = weight;
        },
      ),
      bottomButton: OnboardingBottomButton(
        label: l10n.done,
        onPressed: _onDone,
      ),
    );
  }
}
