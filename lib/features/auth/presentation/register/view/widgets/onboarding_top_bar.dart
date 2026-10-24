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
          GestureDetector(
            onTap: onBackTap ?? () => context.pop(),
            child: Image.asset(AppImages.back, width: 36, height: 36),
          ),
          Image.asset(AppImages.superFitnessLogo, height: 36),
          const SizedBox(width: 36),
        ],
      ),
    );
  }
}
