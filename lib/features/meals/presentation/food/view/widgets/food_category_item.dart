import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class FoodCategoryItem extends StatelessWidget {
  final String categoryName;
  final bool isSelected;
  final VoidCallback onTap;

  const FoodCategoryItem({
    super.key,
    required this.categoryName,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsetsDirectional.symmetric(
          horizontal: AppDimensions.categoryPillHorizontalPadding,
          vertical: AppDimensions.categoryPillVerticalPadding,
        ),
        decoration: _decoration,
        child: Text(categoryName, style: _textStyle),
      ),
    );
  }

  BoxDecoration get _decoration => BoxDecoration(
        color: isSelected ? AppColors.primary : AppColors.transparent,
        borderRadius: const BorderRadius.all(Radius.circular(100)),
      );

  TextStyle get _textStyle => AppTextStyles.medium16.copyWith(
        color: isSelected ? AppColors.white : AppColors.grey30,
        fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
      );
}
