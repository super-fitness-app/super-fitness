import 'package:flutter/material.dart';
import 'package:super_fitness/core/const/app_colors.dart';

class ExerciseHeader extends StatelessWidget {
  const ExerciseHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 30,
      decoration: BoxDecoration(
        color: AppColors.orange,
        shape: BoxShape.circle,
      ),

      child: Icon(Icons.skip_previous),
    );
  }
}
