abstract interface class FitnessLocalDataSource {
  Future<Map<String, dynamic>> getExerciseDetails({
    required String exerciseName,
    String? targetMuscle,
  });

  Future<Map<String, dynamic>> getMealNutrition({
    required String mealName,
    String? goal,
  });
}
