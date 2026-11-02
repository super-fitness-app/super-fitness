import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';

class WorkoutMuscleCard extends StatelessWidget {
  final MuscleEntity muscle;

  const WorkoutMuscleCard({super.key, required this.muscle});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Stack(
        fit: StackFit.expand,
        children: [
          _NetworkImage(url: muscle.image),
          _GradientOverlay(),
          _MuscleLabel(name: muscle.name),
        ],
      ),
    );
  }
}

class _NetworkImage extends StatelessWidget {
  final String url;

  const _NetworkImage({required this.url});

  @override
  Widget build(BuildContext context) {
    if (url.trim().isEmpty) {
      return const ColoredBox(
        color: AppColors.surface,
        child: Center(
          child: Icon(Icons.fitness_center, color: AppColors.grey50, size: 36),
        ),
      );
    }
    return Image.network(
      url,
      fit: BoxFit.cover,
      errorBuilder: (_, _, _) => const ColoredBox(
        color: AppColors.surface,
        child: Center(
          child: Icon(Icons.fitness_center, color: AppColors.grey50, size: 36),
        ),
      ),
      loadingBuilder: (_, child, progress) {
        if (progress == null) return child;
        return const ColoredBox(color: AppColors.surface);
      },
    );
  }
}

class _GradientOverlay extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.transparent,
            AppColors.black.withValues(alpha: 0.8),
          ],
          stops: const [0.4, 1.0],
        ),
      ),
    );
  }
}

class _MuscleLabel extends StatelessWidget {
  final String name;

  const _MuscleLabel({required this.name});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 12,
      left: 12,
      right: 12,
      child: Text(
        name,
        style: const TextStyle(
          color: AppColors.white,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          height: 1.3,
        ),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
