import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/home/data/models/muscle_group_dto.dart';

part 'muscle_groups_response_dto.g.dart';

@JsonSerializable()
class MuscleGroupsResponseDto {
  final String? message;
  final List<MuscleGroupDto>? musclesGroup;

  const MuscleGroupsResponseDto({this.message, this.musclesGroup});

  factory MuscleGroupsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MuscleGroupsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MuscleGroupsResponseDtoToJson(this);
}
