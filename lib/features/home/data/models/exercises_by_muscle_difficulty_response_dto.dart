import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/home/data/models/popular_exercise_dto.dart';

part 'exercises_by_muscle_difficulty_response_dto.g.dart';

@JsonSerializable()
class ExercisesByMuscleDifficultyResponseDto {
  final String? message;
  final int? totalExercises;
  final int? totalPages;
  final int? currentPage;
  final List<PopularExerciseDto>? exercises;

  const ExercisesByMuscleDifficultyResponseDto({
    this.message,
    this.totalExercises,
    this.totalPages,
    this.currentPage,
    this.exercises,
  });

  factory ExercisesByMuscleDifficultyResponseDto.fromJson(
    Map<String, dynamic> json,
  ) => _$ExercisesByMuscleDifficultyResponseDtoFromJson(json);

  Map<String, dynamic> toJson() =>
      _$ExercisesByMuscleDifficultyResponseDtoToJson(this);
}
