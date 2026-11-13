import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/features/profile/presentation/manager/profile_cubit.dart';

class WeightEditView extends StatefulWidget {
  final double? initialWeight;
  final void Function(double)? onDone;

  const WeightEditView({
    super.key,
    this.initialWeight,
    this.onDone,
  });

  @override
  State<WeightEditView> createState() => _WeightEditViewState();
}

class _WeightEditViewState extends State<WeightEditView> {
  static const int _minValue = 30;
  static const int _maxValue = 220;

  late int _selectedValue;
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final cubitWeight = context.read<ProfileCubit?>()?.state.data?.weight.toInt();
    final init = (widget.initialWeight?.toInt() ?? cubitWeight ?? 90)
        .clamp(_minValue, _maxValue);
    _selectedValue = init;
    _pageController = PageController(
      viewportFraction: 0.14,
      initialPage: _selectedValue - _minValue,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onDone() {
    final cubit = context.read<ProfileCubit?>();
    cubit?.doEvent(UpdateWeightEvent(_selectedValue.toDouble()));
    widget.onDone?.call(_selectedValue.toDouble());
    Navigator.of(context).maybePop();
  }

  @override
  Widget build(BuildContext context) {
    final itemCount = _maxValue - _minValue + 1;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(AppImages.authBackground, fit: BoxFit.cover),
          Container(color: AppColors.onboardingOverlay),
          SafeArea(
            child: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildTopBar(context),
                    const SizedBox(height: 18),
                    Image.asset(AppImages.superFitnessLogo, height: 42),
                    const SizedBox(height: 36),
                    Text(
                      'WHAT IS YOUR WEIGHT ?',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.bold20.copyWith(
                        color: AppColors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'This Helps Us Create Your Personalized Plan',
                      textAlign: TextAlign.center,
                      style: AppTextStyles.regular13.copyWith(
                        color: AppColors.grey30,
                      ),
                    ),
                    const SizedBox(height: 28),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(32),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 35, sigmaY: 35),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.fromLTRB(16, 24, 16, 20),
                          decoration: BoxDecoration(
                            color: AppColors.onboardingCard,
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                              color: AppColors.white.withValues(alpha: 0.15),
                              width: 1,
                            ),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Kg',
                                style: TextStyle(
                                  color: AppColors.orangeBase,
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                height: 54,
                                child: PageView.builder(
                                  controller: _pageController,
                                  itemCount: itemCount,
                                  onPageChanged: (index) {
                                    setState(() {
                                      _selectedValue = _minValue + index;
                                    });
                                  },
                                  itemBuilder: (context, index) {
                                    final val = _minValue + index;
                                    final isSelected = val == _selectedValue;
                                    return Center(
                                      child: Text(
                                        '$val',
                                        style: TextStyle(
                                          color: isSelected
                                              ? AppColors.orangeBase
                                              : Colors.white60,
                                          fontSize: isSelected ? 34 : 20,
                                          fontWeight: isSelected
                                              ? FontWeight.bold
                                              : FontWeight.w600,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Icon(
                                Icons.arrow_drop_up,
                                color: AppColors.orangeBase,
                                size: 28,
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: double.infinity,
                                height: 48,
                                child: ElevatedButton(
                                  onPressed: _onDone,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.orangeBase,
                                    foregroundColor: AppColors.white,
                                    shape: const StadiumBorder(),
                                    elevation: 0,
                                  ),
                                  child: const Text(
                                    'Done',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.5,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.of(context).maybePop(),
        child: Image.asset(AppImages.back, width: 36, height: 36),
      ),
    );
  }
}
