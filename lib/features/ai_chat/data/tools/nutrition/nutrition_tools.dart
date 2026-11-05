import 'package:injectable/injectable.dart';

@lazySingleton
class NutritionTools {
  const NutritionTools();

  Future<String> searchMeals(Map<String, dynamic> arguments) async {
    return '[]';
  }

  Future<String> getMealDetails(Map<String, dynamic> arguments) async {
    return '{}';
  }
}
