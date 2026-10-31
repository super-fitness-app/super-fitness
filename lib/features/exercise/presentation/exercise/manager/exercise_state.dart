import 'package:equatable/equatable.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/exercise_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';

typedef ExerciseState = BaseState<ExerciseData>;

class ExerciseData extends Equatable {
  final List<ExerciseEntity> exercises;
  final List<MuscleEntity> muscles;
  final List<DifficultyLevelEntity> levels;

  const ExerciseData({
    this.exercises = const [],
    this.muscles = const [],
    this.levels = const [],
  });

  ExerciseData copyWith({
    List<ExerciseEntity>? exercises,
    List<MuscleEntity>? muscles,
    List<DifficultyLevelEntity>? levels,
  }) {
    return ExerciseData(
      exercises: exercises ?? this.exercises,
      muscles: muscles ?? this.muscles,
      levels: levels ?? this.levels,
    );
  }

  @override
  List<Object?> get props => [exercises, muscles, levels];
}
