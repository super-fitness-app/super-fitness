import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/meals/api/client/meals_api_client.dart';
import 'package:super_fitness/features/meals/data/data_source/remote/meals_remote_data_source.dart';
import 'package:super_fitness/features/meals/data/models/categories_response.dart';
import 'package:super_fitness/features/meals/data/models/meals_details_response.dart';
import 'package:super_fitness/features/meals/data/models/meals_response.dart';

@Injectable(as: MealsRemoteDataSource)
class MealsRemoteDataSourceImpl implements MealsRemoteDataSource {
  final MealsApiClient _mealsApiClient;

  MealsRemoteDataSourceImpl(this._mealsApiClient);

  @override
  Future<CategoriesResponse> getCategories() {
    return _mealsApiClient.getCategories();
  }

  @override
  Future<MealsResponse> getMealsByCategory(String category) {
    return _mealsApiClient.getMealsByCategory(category);
  }

  @override
  Future<MealDetailsResponse> getMealDetails(String mealId) {
    return _mealsApiClient.getMealDetails(mealId);
  }
}
