class MealDetailsEntity {
  final String? id;
  final String? name;
  final String? category;
  final String? area;
  final String? instructions;
  final String? imageUrl;
  final String? youtubeUrl;
  final String? sourceUrl;
  final List<MealIngredientEntity> ingredients;

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
  });
}

class MealIngredientEntity {
  final String name;
  final String? measure;

  const MealIngredientEntity({
    required this.name,
    this.measure,
  });
}