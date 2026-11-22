import 'package:equatable/equatable.dart';

class MealDetailsEntity extends Equatable {
  final String? id;
  final String? name;
  final String? category;
  final String? area;
  final String? instructions;
  final String? imageUrl;
  final String? youtubeUrl;
  final String? sourceUrl;
  final List<MealIngredientEntity> ingredients;
  final String energy;
  final String protein;
  final String carbs;
  final String fat;

  const MealDetailsEntity({
    this.id,
    this.name,
    this.category,
    this.area,
    this.instructions,
    this.imageUrl,
    this.youtubeUrl,
    this.sourceUrl,
    this.ingredients = const [],
    this.energy = '100 K',
    this.protein = '15 G',
    this.carbs = '58 G',
    this.fat = '20 G',
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        area,
        instructions,
        imageUrl,
        youtubeUrl,
        sourceUrl,
        ingredients,
        energy,
        protein,
        carbs,
        fat,
      ];
}

class MealIngredientEntity extends Equatable {
  final String name;
  final String? measure;

  const MealIngredientEntity({
    required this.name,
    this.measure,
  });

  @override
  List<Object?> get props => [name, measure];
}
