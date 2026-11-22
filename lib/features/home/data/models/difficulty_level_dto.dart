import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/home/domain/entities/difficulty_level_entity.dart';

part 'difficulty_level_dto.g.dart';

@JsonSerializable()
class DifficultyLevelDto {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;

  const DifficultyLevelDto({this.id, this.name});

  factory DifficultyLevelDto.fromJson(Map<String, dynamic> json) =>
      _$DifficultyLevelDtoFromJson(json);

  Map<String, dynamic> toJson() => _$DifficultyLevelDtoToJson(this);

  DifficultyLevelEntity toEntity() {
    return DifficultyLevelEntity(id: id ?? '', name: name?.trim() ?? '');
  }
}
