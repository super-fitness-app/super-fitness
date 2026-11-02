import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_group_entity.dart';

part 'muscle_group_model.g.dart';

@JsonSerializable()
class MuscleGroupModel {
  @JsonKey(name: '_id')
  final String? id;
  final String? name;

  const MuscleGroupModel({this.id, this.name});

  factory MuscleGroupModel.fromJson(Map<String, dynamic> json) =>
      _$MuscleGroupModelFromJson(json);

  Map<String, dynamic> toJson() => _$MuscleGroupModelToJson(this);

  MuscleGroupEntity toEntity() => MuscleGroupEntity(
        id: id ?? '',
        name: name ?? '',
      );
}
