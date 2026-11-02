import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/difficulty_level_model.dart';
import 'package:super_fitness/features/exercise/domain/entities/difficulty_level_entity.dart';

part 'difficulty_levels_response_model.g.dart';

@JsonSerializable()
class DifficultyLevelsResponseModel {
  final String message;

  final List<DifficultyLevelModel> levels;

  const DifficultyLevelsResponseModel({
    required this.message,
    required this.levels,
  });

  factory DifficultyLevelsResponseModel.fromJson(Map<String, dynamic> json) =>
      _$DifficultyLevelsResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$DifficultyLevelsResponseModelToJson(this);

  List<DifficultyLevelEntity> toEntities() {
    return levels.map((level) => level.toEntity()).toList();
  }
}
