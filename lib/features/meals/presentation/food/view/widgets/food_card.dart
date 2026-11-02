import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/const/app_dimensions.dart';
import 'package:super_fitness/core/const/app_text_styles.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';

class FoodCard extends StatelessWidget {
  final MealEntity meal;
  final VoidCallback onTap;

  const FoodCard({
    super.key,
    required this.meal,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(AppDimensions.cardRadius),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            _CardMealImage(imageUrl: meal.imageUrl),
            const _CardGradientOverlay(),
            _CardTitle(title: meal.name ?? ''),
          ],
        ),
      ),
    );
  }
}

class _CardMealImage extends StatelessWidget {
  final String? imageUrl;
  const _CardMealImage({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final url = imageUrl;
    if (url == null || url.isEmpty) {
      return const _CardImagePlaceholder();
    }
    return CachedNetworkImage(
      imageUrl: url,
      fit: BoxFit.cover,
      placeholder: (_, _) => const _CardImageShimmer(),
      errorWidget: (_, _, _) => const _CardImagePlaceholder(),
    );
  }
}

class _CardImageShimmer extends StatelessWidget {
  const _CardImageShimmer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surfaceVariant,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _CardImagePlaceholder extends StatelessWidget {
  const _CardImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.surface,
      child: const Center(
        child: Icon(
          Icons.restaurant_rounded,
          color: AppColors.grey30,
          size: AppDimensions.defaultIconSize,
        ),
      ),
    );
  }
}

class _CardGradientOverlay extends StatelessWidget {
  const _CardGradientOverlay();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: const [0.0, 0.4, 0.75, 1.0],
          colors: [
            AppColors.transparent,
            AppColors.transparent,
            AppColors.black.withValues(alpha: 0.7),
            AppColors.black.withValues(alpha: 0.9),
          ],
        ),
      ),
    );
  }
}

class _CardTitle extends StatelessWidget {
  final String title;
  const _CardTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return PositionedDirectional(
      start: 12,
      end: 12,
      bottom: 16,
      child: Text(
        title,
        style: AppTextStyles.bold16,
        textAlign: TextAlign.center,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
