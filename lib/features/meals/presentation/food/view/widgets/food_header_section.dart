import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class FoodHeaderSection extends StatelessWidget {
  const FoodHeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: AppDimensions.defaultScreenPadding,
        vertical: AppDimensions.defaultScreenPadding,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: const _HeaderBackButton(),
          ),
          Text(
            localizations.foodRecommendation,
            style: AppTextStyles.bold24,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _HeaderBackButton extends StatelessWidget {
  const _HeaderBackButton();

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return InkWell(
      key: const Key('food_header_back_button'),
      onTap: () => Navigator.maybePop(context),
      borderRadius: const BorderRadius.all(
        Radius.circular(AppDimensions.headerIconSize),
      ),
      child: Container(
        width: AppDimensions.headerIconSize,
        height: AppDimensions.headerIconSize,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: Transform.scale(
          scaleX: isRtl ? -1 : 1,
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.white,
            size: 18,
          ),
        ),
      ),
    );
  }
}
