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

class SelectHeightView extends StatefulWidget {
  final VoidCallback? onNext;
  final VoidCallback? onBack;

  const SelectHeightView({
    super.key,
    this.onNext,
    this.onBack,
  });

  @override
  State<SelectHeightView> createState() => _SelectHeightViewState();
}

class _SelectHeightViewState extends State<SelectHeightView> {
  late int _selectedHeight;

  @override
  void initState() {
    super.initState();
    _selectedHeight = context.read<RegisterCubit>().state.data.height ?? 170;
  }

  void _onNext() {
    context.read<RegisterCubit>().doEvent(UpdateHeightEvent(_selectedHeight));
    if (widget.onNext != null) {
      widget.onNext!();
    } else {
      context.push(AppRoutes.selectGoal);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return OnboardingScaffold(
      onBackTap: widget.onBack,
      stepImage: AppImages.step4,
      title: l10n.whatIsYourHeight,
      subtitle: l10n.personalizedPlanSubtitle,
      content: HorizontalNumberPicker(
        minValue: 100,
        maxValue: 250,
        initialValue: _selectedHeight,
        unitLabel: l10n.cm,
        onChanged: (height) => _selectedHeight = height,
      ),
      bottomButton: OnboardingBottomButton(
        label: l10n.next,
        onPressed: _onNext,
      ),
    );
  }
}
