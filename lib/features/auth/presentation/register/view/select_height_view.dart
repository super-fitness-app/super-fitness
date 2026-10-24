import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import '../manager/register_cubit.dart';
import 'widgets/horizontal_number_picker.dart';
import 'widgets/onboarding_bottom_button.dart';
import 'widgets/onboarding_scaffold.dart';

class SelectHeightView extends StatefulWidget {
  const SelectHeightView({super.key});

  @override
  State<SelectHeightView> createState() => _SelectHeightViewState();
}

class _SelectHeightViewState extends State<SelectHeightView> {
  late int _selectedHeight;

  @override
  void initState() {
    super.initState();
    _selectedHeight = context.read<RegisterCubit>().state.data?.height ?? 170;
  }

  void _onNext() {
    context.read<RegisterCubit>().updateHeightIntent(_selectedHeight);
    context.push(AppRoutes.selectGoal);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      stepImage: AppImages.step4,
      title: AppStrings.whatIsYourHeight,
      subtitle: AppStrings.personalizedPlanSubtitle,
      content: HorizontalNumberPicker(
        minValue: 100,
        maxValue: 250,
        initialValue: _selectedHeight,
        unitLabel: AppStrings.cm,
        onChanged: (height) => _selectedHeight = height,
      ),
      bottomButton: OnboardingBottomButton(
        label: AppStrings.next,
        onPressed: _onNext,
      ),
    );
  }
}
