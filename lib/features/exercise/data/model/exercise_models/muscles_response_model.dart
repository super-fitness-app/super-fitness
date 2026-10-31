import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/muscle_model.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
part 'muscles_response_model.g.dart';

@JsonSerializable()
class MusclesResponseModel {
  final String message;
  final int totalMuscles;
  final List<MuscleModel> muscles;

  const MusclesResponseModel({
    required this.message,
    required this.totalMuscles,
    required this.muscles,
  });

  factory MusclesResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MusclesResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$MusclesResponseModelToJson(this);
  List<MuscleEntity> toEntities() {
    return muscles.map((muscle) => muscle.toEntity()).toList();
  }
}
