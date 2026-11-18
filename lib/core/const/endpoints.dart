abstract final class Endpoints {
  // Base URLs
  static const String baseUrl = 'https://fitness.elevateegy.com/api/v1/';
  static const String mealBaseUrl = 'https://www.themealdb.com/api/json/v1/1/';

  // Muscle endpoints
  static const String randomMuscles = 'muscles/random';
  static const String muscles = 'muscles';
  static const String musclesGroup = 'musclesGroup/{id}';

  // Meals endpoints
  static const String mealCategories = 'categories.php';
  static const String mealCategoriesUrl = '$mealBaseUrl$mealCategories';
}
