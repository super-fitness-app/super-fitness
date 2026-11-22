import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/home/data/models/muscle_dto.dart';

part 'random_muscles_response_dto.g.dart';

@JsonSerializable()
class RandomMusclesResponseDto {
  final String? message;
  final int? totalMuscles;
  final List<MuscleDto>? muscles;

  const RandomMusclesResponseDto({
    this.message,
    this.totalMuscles,
    this.muscles,
  });

  factory RandomMusclesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$RandomMusclesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$RandomMusclesResponseDtoToJson(this);
}
