import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_images.dart';
import '../manager/register_cubit.dart';
import 'widgets/gender_option_button.dart';
import 'widgets/onboarding_bottom_button.dart';
import 'widgets/onboarding_scaffold.dart';

class SelectGenderView extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const SelectGenderView({
    super.key,
    this.onNext,
    this.onBack,
  });

  @override
  State<SelectGenderView> createState() => _SelectGenderViewState();
}

class _SelectGenderViewState extends State<SelectGenderView> {
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _selectedGender = context.read<RegisterCubit>().state.data.gender;
  }

  void _onSelect(String gender) {
    setState(() => _selectedGender = gender);
  }

  void _onNext() {
    if (_selectedGender == null) return;
    context.read<RegisterCubit>().doEvent(UpdateGenderEvent(_selectedGender!));
    if (widget.onNext != null) {
      widget.onNext!();
    } else {
      context.push(AppRoutes.selectAge);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OnboardingScaffold(
      onBackTap: widget.onBack,
      stepImage: AppImages.step1,
      title: l10n.tellUsAboutYourself,
      subtitle: l10n.weNeedToKnowYourGender,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          GenderOptionButton(
            label: l10n.male,
            icon: Icons.male,
            isSelected: _selectedGender == 'male',
            onTap: () => _onSelect('male'),
          ),
          const SizedBox(height: 20),
          GenderOptionButton(
            label: l10n.female,
            icon: Icons.female,
            isSelected: _selectedGender == 'female',
            onTap: () => _onSelect('female'),
          ),
        ],
      ),
      bottomButton: OnboardingBottomButton(
        label: l10n.next,
        isEnabled: _selectedGender != null,
        onPressed: _onNext,
      ),
    );
  }
}
