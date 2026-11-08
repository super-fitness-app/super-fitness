import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/fitness_card_entity.dart';

class FitnessCardWidget extends StatelessWidget {
  final FitnessCardEntity card;

  const FitnessCardWidget({super.key, required this.card});

  @override
  Widget build(BuildContext context) {
    final isMeal = card.cardType == FitnessCardType.meal;

    return Container(
      margin: const EdgeInsetsDirectional.only(top: 10),
      padding: const EdgeInsetsDirectional.all(12),
      decoration: BoxDecoration(
        color: AppColors.blackBase,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isMeal ? AppColors.success : AppColors.primary,
          width: 1.2,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          _CardHeader(
            title: card.title,
            badge: card.badge,
            isMeal: isMeal,
          ),
          if (card.subtitle != null && card.subtitle!.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              card.subtitle!,
              style: AppTextStyles.regular12.copyWith(color: AppColors.grey30),
            ),
          ],
          if (card.metrics.isNotEmpty) ...[
            const SizedBox(height: 8),
            _MetricsWrap(metrics: card.metrics),
          ],
          if (card.bulletPoints.isNotEmpty) ...[
            const SizedBox(height: 8),
            _BulletPointsList(bullets: card.bulletPoints),
          ],
        ],
      ),
    );
  }
}

class _CardHeader extends StatelessWidget {
  final String title;
  final String? badge;
  final bool isMeal;

  const _CardHeader({
    required this.title,
    required this.badge,
    required this.isMeal,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          isMeal ? Icons.restaurant_menu_rounded : Icons.fitness_center_rounded,
          color: isMeal ? AppColors.success : AppColors.primary,
          size: 18,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            title,
            style: AppTextStyles.extraBold14.copyWith(color: AppColors.white),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (badge != null && badge!.isNotEmpty)
          Container(
            padding: const EdgeInsetsDirectional.symmetric(
              horizontal: 8,
              vertical: 2,
            ),
            decoration: BoxDecoration(
              color: isMeal
                  ? AppColors.success.withValues(alpha: 0.2)
                  : AppColors.primary.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              badge!,
              style: AppTextStyles.regular12.copyWith(
                color: isMeal ? AppColors.success : AppColors.primary,
              ),
            ),
          ),
      ],
    );
  }
}

class _MetricsWrap extends StatelessWidget {
  final Map<String, String> metrics;

  const _MetricsWrap({required this.metrics});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 6,
      runSpacing: 4,
      children: metrics.entries.map((entry) {
        return Container(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: 8,
            vertical: 4,
          ),
          decoration: BoxDecoration(
            color: AppColors.surfaceVariant,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${entry.key}: ${entry.value}',
            style: AppTextStyles.regular12.copyWith(color: AppColors.white),
          ),
        );
      }).toList(),
    );
  }
}

class _BulletPointsList extends StatelessWidget {
  final List<String> bullets;

  const _BulletPointsList({required this.bullets});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: bullets.take(3).map((cue) {
        return Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '• ',
                style:
                    AppTextStyles.regular12.copyWith(color: AppColors.primary),
              ),
              Expanded(
                child: Text(
                  cue,
                  style:
                      AppTextStyles.regular12.copyWith(color: AppColors.grey20),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
