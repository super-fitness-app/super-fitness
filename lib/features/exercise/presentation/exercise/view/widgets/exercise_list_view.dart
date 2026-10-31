import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/features/exercise/domain/entities/exercise_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/view/widgets/video_player.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/view/widgets/video_thumbnail.dart';

class ExerciseListView extends StatelessWidget {
  final List<MuscleEntity> muscles;
  final List<ExerciseEntity> exercises;

  const ExerciseListView({
    super.key,
    required this.muscles,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(22),
      ),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: exercises.length,
        itemBuilder: (context, index) {
          // final muscle = muscles[index];

          // Avoid accessing exercises out of range.
          final exercise = exercises[index];

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: Row(
              children: [
                SizedBox(
                  width: 120,
                  child: VideoThumbnail(
                    videoUrl: exercise.shortYoutubeDemonstrationLink ?? '',
                    onTap: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.exercise,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '3 groups × 15 reps\n ${exercise.targetMuscleGroup}',
                      ),
                    ],
                  ),
                ),
                if (exercise.inDepthYoutubeExplanationLink != null &&
                    exercise.inDepthYoutubeExplanationLink!.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      final videoUrl = exercise.inDepthYoutubeExplanationLink!;

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ExerciseVideoPlayer(videoUrl: videoUrl),
                        ),
                      );
                    },
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: const BoxDecoration(
                        color: AppColors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: AppColors.background,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
