import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/meals/domain/repo/meals_repo.dart';

@injectable
class GetMealsByCategoryUseCase {
  final MealsRepo _mealsRepo;

  const GetMealsByCategoryUseCase(this._mealsRepo);

  Future<ApiResults<List<MealEntity>>> call(String category) async {
    return await _mealsRepo.getMealsByCategory(category);
  }
}