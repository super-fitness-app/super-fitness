import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class FoodDetailsMacroPills extends StatelessWidget {
  final String energy;
  final String protein;
  final String carbs;
  final String fat;

  const FoodDetailsMacroPills({
    super.key,
    required this.energy,
    required this.protein,
    required this.carbs,
    required this.fat,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _MacroPill(value: energy, label: l10n.energy),
        _MacroPill(value: protein, label: l10n.protein),
        _MacroPill(value: carbs, label: l10n.carbs),
        _MacroPill(value: fat, label: l10n.fat),
      ],
    );
  }
}

class _MacroPill extends StatelessWidget {
  final String value;
  final String label;

  const _MacroPill({
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimensions.macroPillSize,
      height: AppDimensions.macroPillSize,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.cardBackground,
        border: Border.all(
          color: AppColors.grey70,
          width: 1.0,
        ),
      ),
      padding: const EdgeInsets.all(4),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: AppTextStyles.bold16.copyWith(height: 1.1),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: AppTextStyles.regular12.copyWith(
                  color: AppColors.primary,
                  height: 1.1,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
