import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';
import 'package:super_fitness/features/meals/domain/repo/meals_repo.dart';

@injectable
class GetMealDetailsUseCase {
  final MealsRepo _mealsRepo;

  const GetMealDetailsUseCase(this._mealsRepo);

  Future<ApiResults<MealDetailsEntity>> call(String mealId) async {
    return await _mealsRepo.getMealDetails(mealId);
  }
}