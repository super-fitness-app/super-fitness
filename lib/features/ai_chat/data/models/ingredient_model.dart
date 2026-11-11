import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/ingredient_entity.dart';

part 'ingredient_model.g.dart';

@JsonSerializable()
class IngredientModel extends Equatable {
  final String id;

  @JsonKey(fromJson: _toLowerCase)
  final String name;

  @JsonKey(name: 'name_ar')
  final String? nameAr;

  final String? image;

  @JsonKey(name: 'kcal_100g')
  final double? caloriesPer100g;

  @JsonKey(name: 'protein_100g')
  final double? proteinPer100g;

  @JsonKey(name: 'carbs_100g')
  final double? carbsPer100g;

  @JsonKey(name: 'fat_100g')
  final double? fatPer100g;

  @JsonKey(name: 'meal_id')
  final String mealId;

  final int position;

  @JsonKey(name: 'qty')
  final double? quantity;

  final String? unit;

  @JsonKey(name: 'measure_raw')
  final String? measureRaw;

  const IngredientModel({
    required this.id,
    required this.name,
    this.nameAr,
    this.image,
    this.caloriesPer100g,
    this.proteinPer100g,
    this.carbsPer100g,
    this.fatPer100g,
    required this.mealId,
    required this.position,
    this.quantity,
    this.unit,
    this.measureRaw,
  });

  static String _toLowerCase(String value) => value.toLowerCase();

  factory IngredientModel.fromJson(Map<String, dynamic> json) =>
      _$IngredientModelFromJson(json);

  Map<String, dynamic> toJson() => _$IngredientModelToJson(this);

  IngredientModel copyWith({
    String? id,
    String? name,
    String? nameAr,
    String? image,
    double? caloriesPer100g,
    double? proteinPer100g,
    double? carbsPer100g,
    double? fatPer100g,
    String? mealId,
    int? position,
    double? quantity,
    String? unit,
    String? measureRaw,
  }) {
    return IngredientModel(
      id: id ?? this.id,
      name: name ?? this.name,
      nameAr: nameAr ?? this.nameAr,
      image: image ?? this.image,
      caloriesPer100g: caloriesPer100g ?? this.caloriesPer100g,
      proteinPer100g: proteinPer100g ?? this.proteinPer100g,
      carbsPer100g: carbsPer100g ?? this.carbsPer100g,
      fatPer100g: fatPer100g ?? this.fatPer100g,
      mealId: mealId ?? this.mealId,
      position: position ?? this.position,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      measureRaw: measureRaw ?? this.measureRaw,
    );
  }

  factory IngredientModel.fromDomain(IngredientEntity entity) =>
      IngredientModel(
        id: entity.id,
        name: entity.name,
        nameAr: entity.nameAr,
        image: entity.image,
        caloriesPer100g: entity.caloriesPer100g,
        proteinPer100g: entity.proteinPer100g,
        carbsPer100g: entity.carbsPer100g,
        fatPer100g: entity.fatPer100g,
        mealId: entity.mealId,
        position: entity.position,
        quantity: entity.quantity,
        unit: entity.unit,
        measureRaw: entity.measureRaw,
      );

  IngredientEntity toEntity() => IngredientEntity(
    id: id,
    name: name,
    nameAr: nameAr,
    image: image,
    caloriesPer100g: caloriesPer100g,
    proteinPer100g: proteinPer100g,
    carbsPer100g: carbsPer100g,
    fatPer100g: fatPer100g,
    mealId: mealId,
    position: position,
    quantity: quantity,
    unit: unit,
    measureRaw: measureRaw,
  );

  @override
  List<Object?> get props => [
    id,
    name,
    nameAr,
    image,
    caloriesPer100g,
    proteinPer100g,
    carbsPer100g,
    fatPer100g,
    mealId,
    position,
    quantity,
    unit,
    measureRaw,
  ];
}
