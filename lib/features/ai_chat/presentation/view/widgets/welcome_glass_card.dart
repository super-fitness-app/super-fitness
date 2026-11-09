import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class WelcomeGlassCard extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomeGlassCard({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 24,
        vertical: 28,
      ),
      decoration: BoxDecoration(
        color: AppColors.frostedGlassSurface,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: AppColors.frostedGlassBorder, width: 1.2),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.smartCoachWelcomeAssist,
            style: AppTextStyles.bold20w800.copyWith(
              color: AppColors.white,
              height: 1.3,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _GetStartedButton(
            label: l10n.smartCoachGetStarted,
            onPressed: onGetStarted,
          ),
        ],
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const _GetStartedButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          shape: const StadiumBorder(),
          elevation: 0,
        ),
        child: Text(
          label,
          style: AppTextStyles.bold16.copyWith(color: AppColors.white),
        ),
      ),
    );
  }
}
