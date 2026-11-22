import 'package:flutter/material.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/presentation/workout/view/widgets/workout_muscle_card.dart';

class WorkoutGrid extends StatelessWidget {
  final List<MuscleEntity> muscles;

  const WorkoutGrid({super.key, required this.muscles});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.85,
      ),
      itemCount: muscles.length,
      itemBuilder: (context, index) =>
          WorkoutMuscleCard(muscle: muscles[index]),
    );
  }
}
