import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';

class FoodDetailsInfoSection extends StatelessWidget {
  final String title;
  final String? instructions;

  const FoodDetailsInfoSection({
    super.key,
    required this.title,
    this.instructions,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TitleText(title: title),
        if (instructions != null && instructions!.trim().isNotEmpty) ...[
          const SizedBox(height: 8),
          _InstructionsPreview(instructions: instructions!.trim()),
        ],
      ],
    );
  }
}

class _TitleText extends StatelessWidget {
  final String title;

  const _TitleText({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.bold24,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _InstructionsPreview extends StatelessWidget {
  final String instructions;

  const _InstructionsPreview({required this.instructions});

  @override
  Widget build(BuildContext context) {
    return Text(
      instructions,
      style: AppTextStyles.regular13.copyWith(color: AppColors.grey30),
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    );
  }
}
