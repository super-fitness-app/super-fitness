import 'package:json_annotation/json_annotation.dart';

part 'meals_details_response.g.dart';

@JsonSerializable()
class MealDetailsResponse {
  final List<MealDetails>? meals;

  const MealDetailsResponse({
    this.meals,
  });

  factory MealDetailsResponse.fromJson(Map<String, dynamic> json) =>
      _$MealDetailsResponseFromJson(json);

  Map<String, dynamic> toJson() =>
      _$MealDetailsResponseToJson(this);
}

@JsonSerializable()
class MealDetails {
  @JsonKey(name: 'idMeal')
  final String? id;

  @JsonKey(name: 'strMeal')
  final String? name;

  @JsonKey(name: 'strMealAlternate')
  final String? alternateName;

  @JsonKey(name: 'strCategory')
  final String? category;

  @JsonKey(name: 'strArea')
  final String? area;

  @JsonKey(name: 'strCountry')
  final String? country;

  @JsonKey(name: 'strInstructions')
  final String? instructions;

  @JsonKey(name: 'strMealThumb')
  final String? imageUrl;

  @JsonKey(name: 'strTags')
  final String? tags;

  @JsonKey(name: 'strYoutube')
  final String? youtubeUrl;

  @JsonKey(name: 'strSource')
  final String? sourceUrl;

  @JsonKey(name: 'strImageSource')
  final String? imageSource;

  @JsonKey(name: 'strCreativeCommonsConfirmed')
  final String? creativeCommonsConfirmed;

  @JsonKey(name: 'dateModified')
  final String? dateModified;

  @JsonKey(includeFromJson: false, includeToJson: false)
  final List<MealIngredient> ingredients;

  const MealDetails({
    this.id,
    this.name,
    this.alternateName,
    this.category,
    this.area,
    this.country,
    this.instructions,
    this.imageUrl,
    this.tags,
    this.youtubeUrl,
    this.sourceUrl,
    this.imageSource,
    this.creativeCommonsConfirmed,
    this.dateModified,
    this.ingredients = const [],
  });

  factory MealDetails.fromJson(Map<String, dynamic> json) {
    final meal = _$MealDetailsFromJson(json);

    return MealDetails(
      id: meal.id,
      name: meal.name,
      alternateName: meal.alternateName,
      category: meal.category,
      area: meal.area,
      country: meal.country,
      instructions: meal.instructions,
      imageUrl: meal.imageUrl,
      tags: meal.tags,
      youtubeUrl: meal.youtubeUrl,
      sourceUrl: meal.sourceUrl,
      imageSource: meal.imageSource,
      creativeCommonsConfirmed: meal.creativeCommonsConfirmed,
      dateModified: meal.dateModified,
      ingredients: List.generate(20, (index) {
        final number = index + 1;
        final ingredient = json['strIngredient$number'] as String?;
        final measure = json['strMeasure$number'] as String?;

        return MealIngredient(
          name: ingredient?.trim().isNotEmpty == true
              ? ingredient!.trim()
              : null,
          measure: measure?.trim().isNotEmpty == true
              ? measure!.trim()
              : null,
        );
      }).where((item) => item.name != null).toList(),
    );
  }

  Map<String, dynamic> toJson() =>
      _$MealDetailsToJson(this);
}

class MealIngredient {
  final String? name;
  final String? measure;

  const MealIngredient({
    this.name,
    this.measure,
  });
}