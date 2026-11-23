import 'package:equatable/equatable.dart';

class MealEntity extends Equatable {
  final String id;
  final String name;
  final String? nameAr;
  final String? category;
  final String? area;
  final String? mealType;
  final double? calories;
  final double? protein;
  final double? carbs;
  final double? fat;
  final bool? nutritionIsEstimate;
  final double? nutritionConfidence;
  final bool? vegetarian;
  final bool? vegan;
  final bool? containsGluten;
  final bool? containsNuts;
  final int? ingredientCount;
  final String? thumbnail;
  final String? youtube;
  final String? tags;
  final int? popularity;

  const MealEntity({
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
}
