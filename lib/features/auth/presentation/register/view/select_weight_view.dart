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

class SelectWeightView extends StatefulWidget {
  const SelectWeightView({super.key});

  @override
  State<SelectWeightView> createState() => _SelectWeightViewState();
}

class _SelectWeightViewState extends State<SelectWeightView> {
  late int _selectedWeight;

  @override
  void initState() {
    super.initState();
    _selectedWeight = context.read<RegisterCubit>().state.data?.weight ?? 70;
  }

  void _onDone() {
    context.read<RegisterCubit>().updateWeightIntent(_selectedWeight);
    context.push(AppRoutes.selectHeight);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      stepImage: AppImages.step3,
      title: AppStrings.whatIsYourWeight,
      subtitle: AppStrings.personalizedPlanSubtitle,
      content: HorizontalNumberPicker(
        minValue: 30,
        maxValue: 220,
        initialValue: _selectedWeight,
        unitLabel: AppStrings.kg,
        onChanged: (weight) => _selectedWeight = weight,
      ),
      bottomButton: OnboardingBottomButton(
        label: AppStrings.done,
        onPressed: _onDone,
      ),
    );
  }
}
