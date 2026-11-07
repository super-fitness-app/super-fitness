import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/exercise/data/models/muscle_model.dart';

part 'muscles_by_group_response_model.g.dart';

@JsonSerializable()
class MusclesByGroupResponseModel {
  final String? message;
  final int? totalMuscles;
  final List<MuscleModel>? muscles;

  const MusclesByGroupResponseModel({
    this.message,
    this.totalMuscles,
    this.muscles,
  });

  factory MusclesByGroupResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MusclesByGroupResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MusclesByGroupResponseModelToJson(this);
}
