sealed class ExerciseEvent {}

class GetExercisesByMuscleAndDifficultyEvent extends ExerciseEvent {
  final String language;
  final String difficultyLevelId;
  final String primeMoverMuscleId;

  GetExercisesByMuscleAndDifficultyEvent({
    required this.language,
    required this.difficultyLevelId,
    required this.primeMoverMuscleId,
  });
}

class GetAllDifficultyLevelsEvent extends ExerciseEvent {
  final String language;

  GetAllDifficultyLevelsEvent({required this.language});
}
