import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_images.dart';
import '../manager/register_cubit.dart';
import 'widgets/horizontal_number_picker.dart';
import 'widgets/onboarding_bottom_button.dart';
import 'widgets/onboarding_scaffold.dart';

class SelectAgeView extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const SelectAgeView({
    super.key,
    this.onNext,
    this.onBack,
  });

  @override
  State<SelectAgeView> createState() => _SelectAgeViewState();
}

class _SelectAgeViewState extends State<SelectAgeView> {
  late int _selectedAge;

  @override
  void initState() {
    super.initState();
    _selectedAge = context.read<RegisterCubit>().state.data.age ?? 25;
  }

  void _onNext() {
    context.read<RegisterCubit>().doEvent(UpdateAgeEvent(_selectedAge));
    if (widget.onNext != null) {
      widget.onNext!();
    } else {
      context.push(AppRoutes.selectWeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OnboardingScaffold(
      onBackTap: widget.onBack,
      stepImage: AppImages.step2,
      title: l10n.howOldAreYou,
      subtitle: l10n.personalizedPlanSubtitle,
      content: HorizontalNumberPicker(
        minValue: 12,
        maxValue: 99,
        initialValue: _selectedAge,
        unitLabel: l10n.year,
        onChanged: (age) => _selectedAge = age,
      ),
      bottomButton: OnboardingBottomButton(
        label: l10n.next,
        onPressed: _onNext,
      ),
    );
  }
}
