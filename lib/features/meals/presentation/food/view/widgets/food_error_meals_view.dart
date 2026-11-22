import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/core/errors/app_failure.dart';
import 'package:super_fitness/core/ui/extensions/app_failure_extension.dart';
import 'package:super_fitness/core/ui/widgets/app_button.dart';

class FoodErrorMealsView extends StatelessWidget {
  final AppFailure failure;
  final VoidCallback onRetry;

  const FoodErrorMealsView({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding * 2),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              failure.toLocalizedMessage(context),
              style: AppTextStyles.medium16.copyWith(color: AppColors.error),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppDimensions.defaultScreenPadding),
            AppButton(
              text: localizations.retry,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}
