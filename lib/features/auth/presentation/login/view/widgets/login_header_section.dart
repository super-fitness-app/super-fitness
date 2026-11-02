import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class LoginHeaderSection extends StatelessWidget {
  const LoginHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          AppImages.appIcon,
          width: 108,
          height: 60,
          fit: BoxFit.contain,
        ),
        const SizedBox(height: 24),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.heyThere,
                style: AppTextStyles.regular18.copyWith(
                  color: AppColors.white,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.welcomeBack,
                style: AppTextStyles.bold20w800.copyWith(
                  color: AppColors.white,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
