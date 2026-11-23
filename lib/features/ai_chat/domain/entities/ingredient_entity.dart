import 'package:equatable/equatable.dart';

class IngredientEntity extends Equatable {
  final String id;
  final String name;
  final String? nameAr;
  final String? image;
  final double? caloriesPer100g;
  final double? proteinPer100g;
  final double? carbsPer100g;
  final double? fatPer100g;
  final String mealId;
  final int position;
  final double? quantity;
  final String? unit;
  final String? measureRaw;

  const IngredientEntity({
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
