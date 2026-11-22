import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/exercise/domain/entities/exercise_entity.dart';

import 'exercise_model.dart';

part 'exercise_response_model.g.dart';

@JsonSerializable()
class ExerciseResponseModel {
  final String message;
  final int totalExercises;
  final int totalPages;
  final int currentPage;
  final List<ExerciseModel> exercises;

  const ExerciseResponseModel({
    required this.message,
    required this.totalExercises,
    required this.totalPages,
    required this.currentPage,
    required this.exercises,
  });

  factory ExerciseResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ExerciseResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$ExerciseResponseModelToJson(this);

  List<ExerciseEntity> toEntities() {
    return exercises.map((exercise) => exercise.toEntity()).toList();
  }
}
