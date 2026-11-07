import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/exercise/data/models/muscle_group_model.dart';

part 'muscle_groups_response_model.g.dart';

@JsonSerializable()
class MuscleGroupsResponseModel {
  final String? message;
  final List<MuscleGroupModel>? musclesGroup;

  const MuscleGroupsResponseModel({this.message, this.musclesGroup});

  factory MuscleGroupsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MuscleGroupsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MuscleGroupsResponseModelToJson(this);
}
