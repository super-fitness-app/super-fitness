import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class LoginHeaderSection extends StatelessWidget {
  const LoginHeaderSection({
    super.key,
    required this.firstTitle,
    required this.secondTitlel,
    this.anotherHeight,
  });
  final String firstTitle;
  final String secondTitlel;
  final double? anotherHeight;
  @override
  Widget build(BuildContext context) {
    AppLocalizations.of(context)!;
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
        SizedBox(height: anotherHeight ?? 24),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstTitle,
                style: AppTextStyles.regular18.copyWith(color: AppColors.white),
              ),
              const SizedBox(height: 4),
              Text(
                secondTitlel,
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
