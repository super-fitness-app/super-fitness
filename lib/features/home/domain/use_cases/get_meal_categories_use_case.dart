import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';

@injectable
class GetMealCategoriesUseCase {
  final HomeRepo _homeRepo;

  const GetMealCategoriesUseCase(this._homeRepo);

  Future<ApiResults<List<MealCategoryEntity>>> call() {
    return _homeRepo.getMealCategories();
  }
}
