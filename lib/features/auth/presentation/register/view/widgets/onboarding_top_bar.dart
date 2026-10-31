import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:super_fitness/core/const/app_images.dart';

class OnboardingTopBar extends StatelessWidget {
  final VoidCallback? onBackTap;

  const OnboardingTopBar({super.key, this.onBackTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: onBackTap ?? () => context.pop(),
            icon: Image.asset(AppImages.back, width: 36, height: 36),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
            splashRadius: 24,
          ),
          Image.asset(AppImages.superFitnessLogo, height: 36),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
