import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';

part 'muscle_group_dto.g.dart';

@JsonSerializable()
class MuscleGroupDto {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;

  const MuscleGroupDto({this.id, this.name});

  factory MuscleGroupDto.fromJson(Map<String, dynamic> json) =>
      _$MuscleGroupDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MuscleGroupDtoToJson(this);

  MuscleGroupEntity toEntity() {
    return MuscleGroupEntity(id: id ?? '', name: name?.trim() ?? '');
  }
}
