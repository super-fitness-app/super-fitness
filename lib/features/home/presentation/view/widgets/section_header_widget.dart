import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/ui/extensions/context_extension.dart';

class SectionHeaderWidget extends StatelessWidget {
  final String title;
  final String? actionTitle;
  final VoidCallback? onActionTap;
  final EdgeInsetsGeometry padding;

  const SectionHeaderWidget({
    super.key,
    required this.title,
    this.actionTitle,
    this.onActionTap,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title,
            style:
                context.textTheme.titleMedium?.copyWith(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ) ??
                const TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
          ),
          if (onActionTap != null)
            GestureDetector(
              onTap: onActionTap,
              behavior: HitTestBehavior.opaque,
              child: Text(
                actionTitle ?? context.l10n.seeAll,
                style:
                    context.textTheme.bodyMedium?.copyWith(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ) ??
                    const TextStyle(
                      color: AppColors.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
              ),
            ),
        ],
      ),
    );
  }
}
