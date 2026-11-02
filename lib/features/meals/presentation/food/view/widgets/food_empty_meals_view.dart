import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class FoodEmptyMealsView extends StatelessWidget {
  const FoodEmptyMealsView({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding * 2),
      child: Center(
        child: Text(
          localizations.noMealsFound,
          style: AppTextStyles.medium16.copyWith(color: AppColors.grey30),
        ),
      ),
    );
  }
}
