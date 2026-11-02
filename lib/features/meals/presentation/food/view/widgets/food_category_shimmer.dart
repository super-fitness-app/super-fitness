import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';

class FoodCategoryShimmer extends StatefulWidget {
  const FoodCategoryShimmer({super.key});

  @override
  State<FoodCategoryShimmer> createState() => _FoodCategoryShimmerState();
}

class _FoodCategoryShimmerState extends State<FoodCategoryShimmer>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  static const List<double> _pillWidths = [72, 88, 64, 80, 76];

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
      builder: (context, _) => SizedBox(
        height: 48,
        child: ListView.separated(
          padding: const EdgeInsetsDirectional.symmetric(
            horizontal: AppDimensions.defaultScreenPadding,
          ),
          scrollDirection: Axis.horizontal,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: _pillWidths.length,
          separatorBuilder: (_, _) =>
              const SizedBox(width: AppDimensions.categorySpacing),
          itemBuilder: (_, index) => _ShimmerPill(
            width: _pillWidths[index],
            opacity: _animation.value,
          ),
        ),
      ),
    );
  }
}

class _ShimmerPill extends StatelessWidget {
  final double width;
  final double opacity;

  const _ShimmerPill({required this.width, required this.opacity});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: width,
        height: 38,
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.all(Radius.circular(100)),
        ),
      ),
    );
  }
}
