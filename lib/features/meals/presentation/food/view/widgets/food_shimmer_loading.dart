import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';

class FoodShimmerLoading extends StatefulWidget {
  const FoodShimmerLoading({super.key});

  @override
  State<FoodShimmerLoading> createState() => _FoodShimmerLoadingState();
}

class _FoodShimmerLoadingState extends State<FoodShimmerLoading>
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
      builder: (context, _) => GridView.builder(
        padding: const EdgeInsets.all(AppDimensions.defaultScreenPadding),
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppDimensions.gridSpacing,
          mainAxisSpacing: AppDimensions.gridSpacing,
          childAspectRatio: AppDimensions.cardAspectRatio,
        ),
        itemCount: 6,
        itemBuilder: (_, _) => _ShimmerCard(opacity: _animation.value),
      ),
    );
  }
}

class _ShimmerCard extends StatelessWidget {
  final double opacity;
  const _ShimmerCard({required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.all(
            Radius.circular(AppDimensions.cardRadius),
          ),
        ),
      ),
    );
  }
}
