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

class SelectAgeView extends StatefulWidget {
  const SelectAgeView({super.key});

  @override
  State<SelectAgeView> createState() => _SelectAgeViewState();
}

class _SelectAgeViewState extends State<SelectAgeView> {
  late int _selectedAge;

  @override
  void initState() {
    super.initState();
    _selectedAge = context.read<RegisterCubit>().state.data?.age ?? 25;
  }

  void _onNext() {
    context.read<RegisterCubit>().updateAgeIntent(_selectedAge);
    context.push(AppRoutes.selectWeight);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      stepImage: AppImages.step2,
      title: AppStrings.howOldAreYou,
      subtitle: AppStrings.personalizedPlanSubtitle,
      content: HorizontalNumberPicker(
        minValue: 12,
        maxValue: 99,
        initialValue: _selectedAge,
        unitLabel: AppStrings.year,
        onChanged: (age) => _selectedAge = age,
      ),
      bottomButton: OnboardingBottomButton(
        label: AppStrings.next,
        onPressed: _onNext,
      ),
    );
  }
}
