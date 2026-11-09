import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';

class CoachRobotAvatar extends StatelessWidget {
  final double size;

  const CoachRobotAvatar({super.key, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: EdgeInsetsDirectional.all(size * 0.08),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.surface,
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.4),
          width: 1.2,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          AppImages.robot,
          fit: BoxFit.contain,
          errorBuilder: (_, _, _) => Icon(
            Icons.smart_toy_rounded,
            color: AppColors.primary,
            size: size * 0.5,
          ),
        ),
      ),
    );
  }
}
