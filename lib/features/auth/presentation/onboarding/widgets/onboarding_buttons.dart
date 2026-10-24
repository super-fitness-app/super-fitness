import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/core/ui/widgets/app_button.dart';

class OnboardingButtons extends StatelessWidget {
  final int currentIndex;
  final int totalPages;
  final VoidCallback onNext;
  final VoidCallback onBack;
  final VoidCallback onFinish;

  const OnboardingButtons({
    super.key,
    required this.currentIndex,
    required this.totalPages,
    required this.onNext,
    required this.onBack,
    required this.onFinish,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isFirst = currentIndex == 0;
    final isLast = currentIndex == totalPages - 1;

    if (isFirst) {
      return _PrimaryPillButton(
        text: l10n.onboardingNext,
        isFullWidth: true,
        onPressed: onNext,
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _OutlinedPillButton(text: l10n.onboardingBack, onPressed: onBack),
        _PrimaryPillButton(
          text: isLast ? l10n.onboardingDoIt : l10n.onboardingNext,
          isFullWidth: false,
          onPressed: isLast ? onFinish : onNext,
        ),
      ],
    );
  }
}

class _PrimaryPillButton extends StatelessWidget {
  final String text;
  final bool isFullWidth;
  final VoidCallback onPressed;

  const _PrimaryPillButton({
    required this.text,
    required this.isFullWidth,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      width: isFullWidth
          ? double.infinity
          : AppDimensions.onboardingButtonWidth,
      height: 44,
      backgroundColor: AppColors.primary,
      textStyle: AppTextStyles.extraBold14.copyWith(color: AppColors.white),
    );
  }
}

class _OutlinedPillButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _OutlinedPillButton({required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: AppDimensions.onboardingButtonWidth,
      height: 44,
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: AppColors.transparent,
          foregroundColor: AppColors.white,
          side: const BorderSide(color: AppColors.primary, width: 1.2),
          padding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: AppTextStyles.extraBold14.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
