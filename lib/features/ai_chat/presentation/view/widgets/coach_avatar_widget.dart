import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';

class CoachAvatarWidget extends StatelessWidget {
  final double size;

  const CoachAvatarWidget({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      padding: const EdgeInsetsDirectional.all(4),
      child: Image.asset(
        AppImages.robot,
        fit: BoxFit.contain,
        errorBuilder: (_, _, _) => const Icon(
          Icons.smart_toy_rounded,
          color: AppColors.primary,
          size: 20,
        ),
      ),
    );
  }
}
