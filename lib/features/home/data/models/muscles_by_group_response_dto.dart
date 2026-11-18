import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/home/data/models/muscle_dto.dart';
import 'package:super_fitness/features/home/data/models/muscle_group_dto.dart';

part 'muscles_by_group_response_dto.g.dart';

@JsonSerializable()
class MusclesByGroupResponseDto {
  final String? message;
  final MuscleGroupDto? muscleGroup;
  final List<MuscleDto>? muscles;

  const MusclesByGroupResponseDto({
    this.message,
    this.muscleGroup,
    this.muscles,
  });

  factory MusclesByGroupResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MusclesByGroupResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MusclesByGroupResponseDtoToJson(this);
}
