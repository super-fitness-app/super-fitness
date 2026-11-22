import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/meals/domain/entities/category_entity.dart';
import 'package:super_fitness/features/meals/domain/repo/meals_repo.dart';

@injectable
class GetCategoriesUseCase {
  final MealsRepo _mealsRepo;

  const GetCategoriesUseCase(this._mealsRepo);

  Future<ApiResults<List<CategoryEntity>>> call() async {
    return await _mealsRepo.getCategories();
  }
}
