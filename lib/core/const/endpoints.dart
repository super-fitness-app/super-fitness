abstract final class Endpoints {
  // Base URLs
  static const String baseUrl = 'https://fitness.elevateegy.com/api/v1/';
  static const String mealBaseUrl = 'https://www.themealdb.com/api/json/v1/1/';
  static const String mealsBaseUrl = mealBaseUrl;

  // Auth Endpoints
  static const String loginEndPoint = 'auth/signin';
  static const String register = 'auth/signup';
  static const String changePassword = 'auth/change-password';
  static const String forgetPassword = 'auth/forgotPassword';
  static const String verifyOtp = 'auth/verifyResetCode';
  static const String resetPassword = 'auth/resetPassword';
  static const String deleteAccount = 'auth/deleteMe';

  // Muscle endpoints
  static const String randomMuscles = 'muscles/random';
  static const String muscles = 'muscles';
  static const String musclesGroup = 'musclesGroup/{id}';
  static const String musclesByGroup = 'musclesGroup/by-muscle-group';

  // Exercise & Levels endpoints
  static const String levels = 'levels';
  static const String getAllDifficultyLevels = 'levels';
  static const String exercisesByMuscleDifficulty =
      'exercises/by-muscle-difficulty';

  // Meals endpoints
  static const String mealCategories = 'categories.php';
  static const String mealCategoriesUrl = '$mealBaseUrl$mealCategories';
  static const String filterMealsByCategory = 'filter.php';
  static const String mealDetails = 'lookup.php';
}
