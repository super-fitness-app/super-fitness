import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_images.dart';

class ChatBackgroundStack extends StatelessWidget {
  const ChatBackgroundStack({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          AppImages.background1,
          fit: BoxFit.cover,
          errorBuilder: (_, _, _) => Image.asset(
            AppImages.background,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) =>
                const ColoredBox(color: AppColors.background),
          ),
        ),
        BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
          child: ColoredBox(color: Colors.black.withValues(alpha: 0.35)),
        ),
      ],
    );
  }
}
