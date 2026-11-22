import 'package:json_annotation/json_annotation.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';

part 'meal_category_dto.g.dart';

@JsonSerializable()
class MealCategoryDto {
  final String? idCategory;
  final String? strCategory;
  final String? strCategoryThumb;
  final String? strCategoryDescription;

  const MealCategoryDto({
    this.idCategory,
    this.strCategory,
    this.strCategoryThumb,
    this.strCategoryDescription,
  });

  factory MealCategoryDto.fromJson(Map<String, dynamic> json) =>
      _$MealCategoryDtoFromJson(json);

  Map<String, dynamic> toJson() => _$MealCategoryDtoToJson(this);

  MealCategoryEntity toEntity() {
    return MealCategoryEntity(
      id: idCategory ?? '',
      name: strCategory ?? '',
      thumbnailUrl: strCategoryThumb ?? '',
      description: strCategoryDescription ?? '',
    );
  }
}
