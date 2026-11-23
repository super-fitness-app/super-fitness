import 'package:flutter/material.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class TokenStatusBanner extends StatelessWidget {
  final int totalTokens;
  final bool isApproachingLimit;
  final bool isLocked;
  final VoidCallback onStartNewChat;

  const TokenStatusBanner({
    super.key,
    required this.totalTokens,
    required this.isApproachingLimit,
    required this.isLocked,
    required this.onStartNewChat,
  });

  @override
  Widget build(BuildContext context) {
    if (isLocked) {
      return _LockedBanner(onStartNewChat: onStartNewChat);
    }
    if (isApproachingLimit) {
      return _WarningBanner(totalTokens: totalTokens);
    }
    return const SizedBox.shrink();
  }
}

class _LockedBanner extends StatelessWidget {
  final VoidCallback onStartNewChat;

  const _LockedBanner({required this.onStartNewChat});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
        vertical: 6,
      ),
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF2A1515),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.lock_rounded, color: AppColors.error, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  l10n.smartCoachTokenLocked,
                  style: AppTextStyles.regular12.copyWith(
                    color: AppColors.white,
                    height: 1.3,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: InkWell(
              onTap: onStartNewChat,
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsetsDirectional.symmetric(
                  horizontal: 14,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.add_rounded,
                      color: AppColors.white,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      l10n.smartCoachStartNewChat,
                      style: AppTextStyles.regular12.copyWith(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WarningBanner extends StatelessWidget {
  final int totalTokens;

  const _WarningBanner({required this.totalTokens});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Container(
      width: double.infinity,
      margin: const EdgeInsetsDirectional.symmetric(
        horizontal: 20,
        vertical: 6,
      ),
      padding: const EdgeInsetsDirectional.symmetric(
        horizontal: 12,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2210),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFFFB300).withValues(alpha: 0.6),
          width: 1,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(
            Icons.warning_amber_rounded,
            color: Color(0xFFFFB300),
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              l10n.smartCoachTokenWarning(totalTokens),
              style: AppTextStyles.regular12.copyWith(
                color: const Color(0xFFFFE082),
                height: 1.3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
