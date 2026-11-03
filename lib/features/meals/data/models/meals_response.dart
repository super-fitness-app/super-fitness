import 'package:json_annotation/json_annotation.dart';

part 'meals_response.g.dart';

@JsonSerializable()
class MealsResponse {
  final List<Meal>? meals;

  const MealsResponse({
    this.meals,
  });

  factory MealsResponse.fromJson(Map<String, dynamic> json) =>
      _$MealsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$MealsResponseToJson(this);
}

@JsonSerializable()
class Meal {
  @JsonKey(name: 'idMeal')
  final String? id;

  @JsonKey(name: 'strMeal')
  final String? name;

  @JsonKey(name: 'strMealThumb')
  final String? imageUrl;

  const Meal({
    this.id,
    this.name,
    this.imageUrl,
  });

  factory Meal.fromJson(Map<String, dynamic> json) =>
      _$MealFromJson(json);

  Map<String, dynamic> toJson() => _$MealToJson(this);
}