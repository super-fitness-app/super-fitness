import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/core/ui/extensions/context_extension.dart';
import 'package:super_fitness/features/home/presentation/view/widgets/section_header_widget.dart';

class WorkoutCardData {
  final String title;
  final String imageUrl;

  const WorkoutCardData({required this.title, required this.imageUrl});
}

class UpcomingWorkoutsSection extends StatefulWidget {
  final VoidCallback? onSeeAllTap;
  final List<String>? filterOptions;
  final List<WorkoutCardData>? workouts;
  final int? selectedFilterIndex;
  final bool isLoadingWorkouts;
  final ValueChanged<int>? onFilterChanged;
  final ValueChanged<WorkoutCardData>? onWorkoutTap;

  const UpcomingWorkoutsSection({
    super.key,
    this.onSeeAllTap,
    this.filterOptions,
    this.workouts,
    this.selectedFilterIndex,
    this.isLoadingWorkouts = false,
    this.onFilterChanged,
    this.onWorkoutTap,
  });

  @override
  State<UpcomingWorkoutsSection> createState() =>
      _UpcomingWorkoutsSectionState();
}

class _UpcomingWorkoutsSectionState extends State<UpcomingWorkoutsSection> {
  int _internalSelectedIndex = 0;

  int get _currentIndex => widget.selectedFilterIndex ?? _internalSelectedIndex;

  List<String> _getDefaultFilters(BuildContext context) {
    return [
      context.l10n.fullBody,
      context.l10n.chest,
      context.l10n.arm,
      context.l10n.shoulder,
      context.l10n.back,
      context.l10n.legs,
    ];
  }

  List<WorkoutCardData> _getDefaultWorkouts(BuildContext context) {
    return [
      WorkoutCardData(
        title: context.l10n.chest,
        imageUrl:
            'https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?w=300',
      ),
      WorkoutCardData(
        title: context.l10n.back,
        imageUrl:
            'https://images.unsplash.com/photo-1605296867304-46d5465a13f1?w=300',
      ),
      WorkoutCardData(
        title: context.l10n.arms,
        imageUrl:
            'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=300',
      ),
      WorkoutCardData(
        title: context.l10n.legs,
        imageUrl:
            'https://images.unsplash.com/photo-1434608519344-49d77a699e1d?w=300',
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final filters = widget.filterOptions ?? _getDefaultFilters(context);
    final workouts = widget.workouts ?? _getDefaultWorkouts(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: context.l10n.upcomingWorkouts,
          actionTitle: context.l10n.seeAll,
          onActionTap: widget.onSeeAllTap,
        ),
        const SizedBox(height: 12),

        // Horizontal filter chips list
        if (filters.isNotEmpty)
          SizedBox(
            height: 38,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: filters.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final isSelected = index == _currentIndex;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _internalSelectedIndex = index;
                    });
                    widget.onFilterChanged?.call(index);
                  },
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primaryColor
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primaryColor
                            : Colors.white.withValues(alpha: 0.1),
                        width: 1,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        filters[index],
                        style: TextStyle(
                          color: isSelected
                              ? AppColors.white
                              : AppColors.grey30,
                          fontSize: 13,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        const SizedBox(height: 16),

        // Horizontal workout cards list
        SizedBox(
          height: 125,
          child: widget.isLoadingWorkouts
              ? ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: 4,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) => Container(
                    width: 115,
                    height: 125,
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Center(
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primaryColor,
                        ),
                      ),
                    ),
                  ),
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  itemCount: workouts.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 12),
                  itemBuilder: (context, index) {
                    final workout = workouts[index];
                    return _WorkoutThumbnailCard(
                      workout: workout,
                      onTap: () => widget.onWorkoutTap?.call(workout),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _WorkoutThumbnailCard extends StatelessWidget {
  final WorkoutCardData workout;
  final VoidCallback? onTap;

  const _WorkoutThumbnailCard({required this.workout, this.onTap});

  static const String _fallbackImageUrl =
      'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=300';

  @override
  Widget build(BuildContext context) {
    final effectiveImageUrl = workout.imageUrl.isNotEmpty
        ? workout.imageUrl
        : _fallbackImageUrl;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        width: 115,
        height: 125,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: AppColors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Image.network(
              effectiveImageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: AppColors.surfaceVariant,
                child: const Icon(
                  Icons.fitness_center,
                  color: AppColors.grey50,
                  size: 24,
                ),
              ),
            ),
            // Smooth black-to-transparent linear gradient overlay
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.3),
                      Colors.black.withValues(alpha: 0.85),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Bottom text
            Positioned(
              left: 8,
              right: 8,
              bottom: 8,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      workout.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
