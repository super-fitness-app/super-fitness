import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class OnboardingTopBar extends StatelessWidget {
  final VoidCallback onSkip;

  const OnboardingTopBar({
    super.key,
    required this.onSkip,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsetsDirectional.only(top: 8, end: 20),
        child: TextButton(
          onPressed: onSkip,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.white,
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 12,
              vertical: 8,
            ),
          ),
          child: Text(
            l10n.onboardingSkip,
            style: AppTextStyles.regular16.copyWith(
              color: AppColors.white,
            ),
          ),
        ),
      ),
    );
  }
}
