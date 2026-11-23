import 'package:json_annotation/json_annotation.dart';

part 'popular_exercise_dto.g.dart';

@JsonSerializable()
class PopularExerciseDto {
  @JsonKey(name: '_id')
  final String? id;
  final String? exercise;
  @JsonKey(name: 'difficulty_level')
  final String? difficultyLevel;
  @JsonKey(name: 'target_muscle_group')
  final String? targetMuscleGroup;
  @JsonKey(name: 'prime_mover_muscle')
  final String? primeMoverMuscle;
  @JsonKey(name: 'image')
  final String? image;
  @JsonKey(name: 'short_youtube_demonstration_link')
  final String? shortYoutubeDemonstrationLink;
  @JsonKey(name: 'in_depth_youtube_explanation_link')
  final String? inDepthYoutubeExplanationLink;

  const PopularExerciseDto({
    this.id,
    this.exercise,
    this.difficultyLevel,
    this.targetMuscleGroup,
    this.primeMoverMuscle,
    this.image,
    this.shortYoutubeDemonstrationLink,
    this.inDepthYoutubeExplanationLink,
  });

  factory PopularExerciseDto.fromJson(Map<String, dynamic> json) =>
      _$PopularExerciseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$PopularExerciseDtoToJson(this);
}
