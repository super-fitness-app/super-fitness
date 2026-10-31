import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/ui/extensions/app_failure_extension.dart';
import '../manager/register_cubit.dart';
import 'select_activity_view.dart';
import 'select_age_view.dart';
import 'select_gender_view.dart';
import 'select_goal_view.dart';
import 'select_height_view.dart';
import 'select_weight_view.dart';

class CompleteRegisterView extends StatefulWidget {
  const CompleteRegisterView({super.key});

  @override
  State<CompleteRegisterView> createState() => _CompleteRegisterViewState();
}

class _CompleteRegisterViewState extends State<CompleteRegisterView> {
  late final PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(const AssetImage(AppImages.authBackground), context);
    precacheImage(const AssetImage(AppImages.step1), context);
    precacheImage(const AssetImage(AppImages.step2), context);
    precacheImage(const AssetImage(AppImages.step3), context);
    precacheImage(const AssetImage(AppImages.step4), context);
    precacheImage(const AssetImage(AppImages.step5), context);
    precacheImage(const AssetImage(AppImages.step6), context);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToStep(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleBack() {
    if (_currentIndex > 0) {
      _goToStep(_currentIndex - 1);
    } else {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: BlocListener<RegisterCubit, RegisterState>(
        listenWhen: (prev, curr) =>
            (curr.isSuccess && !prev.isSuccess) ||
            (curr.isFailure && (prev.status != curr.status || prev.failure != curr.failure)),
        listener: (context, state) {
          if (state.isSuccess) {
            context.go(AppRoutes.login);
          } else if (state.isFailure) {
            final failure = state.failure;
            final message = failure?.toLocalizedMessage(context) ??
                state.registerState.errorMessage ??
                AppLocalizations.of(context)?.generalErrorMessage ??
                '';
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            SelectGenderView(onNext: () => _goToStep(1), onBack: _handleBack),
            SelectAgeView(onNext: () => _goToStep(2), onBack: _handleBack),
            SelectWeightView(onNext: () => _goToStep(3), onBack: _handleBack),
            SelectHeightView(onNext: () => _goToStep(4), onBack: _handleBack),
            SelectGoalView(onNext: () => _goToStep(5), onBack: _handleBack),
            SelectActivityView(onBack: _handleBack),
          ],
        ),
      ),
    );
  }
}
