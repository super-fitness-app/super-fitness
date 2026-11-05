import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/core/errors/app_failure.dart';
import 'package:super_fitness/core/ui/extensions/app_failure_extension.dart';

class FoodDetailsErrorView extends StatelessWidget {
  final AppFailure? failure;
  final VoidCallback onRetry;

  const FoodDetailsErrorView({
    super.key,
    required this.failure,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final message = failure?.toLocalizedMessage(context) ??
        l10n.failedToLoadMealDetails;
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.error,
              size: 48,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              style: AppTextStyles.medium16,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            _RetryButton(onRetry: onRetry, label: l10n.retry),
          ],
        ),
      ),
    );
  }
}

class _RetryButton extends StatelessWidget {
  final VoidCallback onRetry;
  final String label;

  const _RetryButton({
    required this.onRetry,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onRetry,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.buttonText,
      ),
    );
  }
}
