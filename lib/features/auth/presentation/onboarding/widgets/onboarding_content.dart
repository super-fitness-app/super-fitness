import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/widgets/onboarding_buttons.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/widgets/onboarding_indicator.dart';

class OnboardingContent extends StatelessWidget {
  final String title;
  final String subtitle;
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onFinish;

  const OnboardingContent({
    super.key,
    required this.title,
    required this.subtitle,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
    required this.onBack,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppDimensions.onboardingContentPaddingHorizontal,
            vertical: AppDimensions.onboardingContentPaddingVertical,
          ),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(50)),
            border: Border(
              top: BorderSide(
                color: AppColors.white.withValues(alpha: 0.12),
                width: 1,
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _ContentTextSection(title: title, subtitle: subtitle),
              const SizedBox(height: 20),
              OnboardingIndicator(
                count: totalPages,
                currentIndex: currentIndex,
              ),
              const SizedBox(height: 24),
              OnboardingButtons(
                currentIndex: currentIndex,
                totalPages: totalPages,
                onNext: onNext,
                onBack: onBack,
                onFinish: onFinish,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ContentTextSection extends StatelessWidget {
  final String title;
  final String subtitle;

  const _ContentTextSection({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: AppTextStyles.headline24.copyWith(
            fontWeight: FontWeight.w700,
            height: 1.25,
            color: AppColors.white,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: AppTextStyles.regular13.copyWith(
            height: 1.45,
            color: AppColors.grey30,
          ),
        ),
      ],
    );
  }
}
