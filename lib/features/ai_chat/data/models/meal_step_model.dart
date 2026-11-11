import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/meal_step_entity.dart';

part 'meal_step_model.g.dart';

@JsonSerializable()
class MealStepModel extends Equatable {
  @JsonKey(name: 'meal_id')
  final String mealId;

  final int position;

  final String text;

  const MealStepModel({
    required this.mealId,
    required this.position,
    required this.text,
  });

  factory MealStepModel.fromJson(Map<String, dynamic> json) =>
      _$MealStepModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealStepModelToJson(this);

  MealStepModel copyWith({String? mealId, int? position, String? text}) {
    return MealStepModel(
      mealId: mealId ?? this.mealId,
      position: position ?? this.position,
      text: text ?? this.text,
    );
  }

  factory MealStepModel.fromDomain(MealStepEntity entity) => MealStepModel(
    mealId: entity.mealId,
    position: entity.position,
    text: entity.text,
  );

  MealStepEntity toEntity() =>
      MealStepEntity(mealId: mealId, position: position, text: text);

  @override
  List<Object?> get props => [mealId, position, text];
}
