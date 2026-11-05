import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class ToolActivityIndicator extends StatelessWidget {
  final String toolName;

  const ToolActivityIndicator({
    super.key,
    required this.toolName,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Container(
        margin: const EdgeInsetsDirectional.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsetsDirectional.symmetric(vertical: 8, horizontal: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.primary, width: 0.5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.build_circle_outlined,
              size: 16,
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            Text(
              'Running tool: $toolName',
              style: AppTextStyles.regular13.copyWith(color: AppColors.grey20),
            ),
          ],
        ),
      ),
    );
  }
}
