import 'package:json_annotation/json_annotation.dart';

part 'categories_response.g.dart';

@JsonSerializable()
class CategoriesResponse {
  final List<Category>? categories;

  const CategoriesResponse({
    this.categories,
  });

  factory CategoriesResponse.fromJson(Map<String, dynamic> json) =>
      _$CategoriesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CategoriesResponseToJson(this);
}

@JsonSerializable()
class Category {
  @JsonKey(name: 'idCategory')
  final String? id;

  @JsonKey(name: 'strCategory')
  final String? name;

  @JsonKey(name: 'strCategoryThumb')
  final String? imageUrl;

  @JsonKey(name: 'strCategoryDescription')
  final String? description;

  const Category({
    this.id,
    this.name,
    this.imageUrl,
    this.description,
  });

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryToJson(this);
}