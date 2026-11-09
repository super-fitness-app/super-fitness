import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/meal_entity.dart';

part 'meal_model.g.dart';

@JsonSerializable()
class MealModel extends Equatable {
  final String id;

  @JsonKey(fromJson: _toLowerCase)
  final String name;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  final String? category;
  final String? area;

  @JsonKey(name: 'meal_type')
  final String? mealType;

  @JsonKey(name: 'kcal')
  final double? calories;

  @JsonKey(name: 'protein_g')
  final double? protein;

  @JsonKey(name: 'carbs_g')
  final double? carbs;

  @JsonKey(name: 'fat_g')
  final double? fat;

  @JsonKey(name: 'nutrition_is_estimate')
  final bool? nutritionIsEstimate;

  @JsonKey(name: 'nutrition_confidence')
  final double? nutritionConfidence;

  final bool? vegetarian;
  final bool? vegan;

  @JsonKey(name: 'contains_gluten')
  final bool? containsGluten;

  @JsonKey(name: 'contains_nuts')
  final bool? containsNuts;

  @JsonKey(name: 'ingredient_count')
  final int? ingredientCount;

  @JsonKey(name: 'thumb')
  final String? thumbnail;

  final String? youtube;
  final String? tags;
  final int? popularity;

  const MealModel({
    required this.id,
    required this.name,
    this.nameAr,
    this.category,
    this.area,
    this.mealType,
    this.calories,
    this.protein,
    this.carbs,
    this.fat,
    this.nutritionIsEstimate,
    this.nutritionConfidence,
    this.vegetarian,
    this.vegan,
    this.containsGluten,
    this.containsNuts,
    this.ingredientCount,
    this.thumbnail,
    this.youtube,
    this.tags,
    this.popularity,
  });

  static String _toLowerCase(String value) => value.toLowerCase();

  factory MealModel.fromJson(Map<String, dynamic> json) =>
      _$MealModelFromJson(json);

  Map<String, dynamic> toJson() => _$MealModelToJson(this);

  MealModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? category,
    String? area,
    String? mealType,
    double? calories,
    double? protein,
    double? carbs,
    double? fat,
    bool? nutritionIsEstimate,
    double? nutritionConfidence,
    bool? vegetarian,
    bool? vegan,
    bool? containsGluten,
    bool? containsNuts,
    int? ingredientCount,
    String? thumbnail,
    String? youtube,
    String? tags,
    int? popularity,
  }) {
    return MealModel(
      id: id ?? this.id,
      name: name?.toLowerCase() ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      category: category ?? this.category,
      area: area ?? this.area,
      mealType: mealType ?? this.mealType,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      carbs: carbs ?? this.carbs,
      fat: fat ?? this.fat,
      nutritionIsEstimate: nutritionIsEstimate ?? this.nutritionIsEstimate,
      nutritionConfidence: nutritionConfidence ?? this.nutritionConfidence,
      vegetarian: vegetarian ?? this.vegetarian,
      vegan: vegan ?? this.vegan,
      containsGluten: containsGluten ?? this.containsGluten,
      containsNuts: containsNuts ?? this.containsNuts,
      ingredientCount: ingredientCount ?? this.ingredientCount,
      thumbnail: thumbnail ?? this.thumbnail,
      youtube: youtube ?? this.youtube,
      tags: tags ?? this.tags,
      popularity: popularity ?? this.popularity,
    );
  }

  factory MealModel.fromDomain(MealEntity entity) => MealModel(
    id: entity.id,
    name: entity.name,
    nameAr: entity.nameAr,
    category: entity.category,
    area: entity.area,
    mealType: entity.mealType,
    calories: entity.calories,
    protein: entity.protein,
    carbs: entity.carbs,
    fat: entity.fat,
    nutritionIsEstimate: entity.nutritionIsEstimate,
    nutritionConfidence: entity.nutritionConfidence,
    vegetarian: entity.vegetarian,
    vegan: entity.vegan,
    containsGluten: entity.containsGluten,
    containsNuts: entity.containsNuts,
    ingredientCount: entity.ingredientCount,
    thumbnail: entity.thumbnail,
    youtube: entity.youtube,
    tags: entity.tags,
    popularity: entity.popularity,
  );

  MealEntity toEntity() => MealEntity(
    id: id,
    name: name,
    nameAr: nameAr,
    category: category,
    area: area,
    mealType: mealType,
    calories: calories,
    protein: protein,
    carbs: carbs,
    fat: fat,
    nutritionIsEstimate: nutritionIsEstimate,
    nutritionConfidence: nutritionConfidence,
    vegetarian: vegetarian,
    vegan: vegan,
    containsGluten: containsGluten,
    containsNuts: containsNuts,
    ingredientCount: ingredientCount,
    thumbnail: thumbnail,
    youtube: youtube,
    tags: tags,
    popularity: popularity,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    nameAr,
    category,
    area,
    mealType,
    calories,
    protein,
    carbs,
    fat,
    nutritionIsEstimate,
    nutritionConfidence,
    vegetarian,
    vegan,
    containsGluten,
    containsNuts,
    ingredientCount,
    thumbnail,
    youtube,
    tags,
    popularity,
  ];

  String? operator [](String other) {
    return null;
  }
}
