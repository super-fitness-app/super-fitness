import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/home/data/models/meal_category_dto.dart';

part 'meal_categories_response_dto.g.dart';

@JsonSerializable()
class MealCategoriesResponseDto {
  final List<MealCategoryDto>? categories;

  const MealCategoriesResponseDto({this.categories});

  factory MealCategoriesResponseDto.fromJson(Map<String, dynamic> json) =>
      _$MealCategoriesResponseDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MealCategoriesResponseDtoToJson(this);
}
