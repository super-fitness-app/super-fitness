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

class SelectWeightView extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const SelectWeightView({
    super.key,
    this.onNext,
    this.onBack,
  });

  @override
  State<SelectWeightView> createState() => _SelectWeightViewState();
}

class _SelectWeightViewState extends State<SelectWeightView> {
  late int _selectedWeight;

  @override
  void initState() {
    super.initState();
    _selectedWeight = context.read<RegisterCubit>().state.data.weight ?? 70;
  }

  void _onDone() {
    context.read<RegisterCubit>().doEvent(UpdateWeightEvent(_selectedWeight));
    if (widget.onNext != null) {
      widget.onNext!();
    } else {
      context.push(AppRoutes.selectHeight);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OnboardingScaffold(
      onBackTap: widget.onBack,
      stepImage: AppImages.step3,
      title: l10n.whatIsYourWeight,
      subtitle: l10n.personalizedPlanSubtitle,
      content: HorizontalNumberPicker(
        minValue: 30,
        maxValue: 220,
        initialValue: _selectedWeight,
        unitLabel: l10n.kg,
        onChanged: (weight) => _selectedWeight = weight,
      ),
      bottomButton: OnboardingBottomButton(
        label: l10n.done,
        onPressed: _onDone,
      ),
    );
  }
}
