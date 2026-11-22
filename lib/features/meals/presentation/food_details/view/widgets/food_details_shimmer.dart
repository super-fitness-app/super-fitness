import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';

class FoodDetailsShimmer extends StatefulWidget {
  const FoodDetailsShimmer({super.key});

  @override
  State<FoodDetailsShimmer> createState() => _FoodDetailsShimmerState();
}

class _FoodDetailsShimmerState extends State<FoodDetailsShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.3, end: 0.8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, _) => SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Opacity(
          opacity: _animation.value,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _ShimmerBox(
                width: double.infinity,
                height: 280,
                borderRadius: BorderRadius.zero,
              ),
              Padding(
                padding: const EdgeInsets.all(
                  AppDimensions.defaultScreenPadding,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _ShimmerBox(width: 220, height: 26),
                    const SizedBox(height: 10),
                    const _ShimmerBox(width: 280, height: 14),
                    const SizedBox(height: 20),
                    const _ShimmerMacroRow(),
                    const SizedBox(height: 24),
                    const _ShimmerBox(width: 140, height: 20),
                    const SizedBox(height: 16),
                    ...List.generate(
                      4,
                      (_) => const Padding(
                        padding: EdgeInsets.only(bottom: 12),
                        child: _ShimmerIngredientRow(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const _ShimmerBox({
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
  }
}

class _ShimmerMacroRow extends StatelessWidget {
  const _ShimmerMacroRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(
        4,
        (_) => Container(
          width: AppDimensions.macroPillSize,
          height: AppDimensions.macroPillSize,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surface,
          ),
        ),
      ),
    );
  }
}

class _ShimmerIngredientRow extends StatelessWidget {
  const _ShimmerIngredientRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _ShimmerBox(width: 130, height: 16),
        _ShimmerBox(width: 60, height: 16),
      ],
    );
  }
}
