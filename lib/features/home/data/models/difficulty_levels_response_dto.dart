import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/home/data/models/difficulty_level_dto.dart';

part 'difficulty_levels_response_dto.g.dart';

@JsonSerializable()
class DifficultyLevelsResponseDto {
  final String? message;
  final List<DifficultyLevelDto>? levels;

  const DifficultyLevelsResponseDto({this.message, this.levels});

  factory DifficultyLevelsResponseDto.fromJson(Map<String, dynamic> json) =>
      _$DifficultyLevelsResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DifficultyLevelsResponseDtoToJson(this);
}
