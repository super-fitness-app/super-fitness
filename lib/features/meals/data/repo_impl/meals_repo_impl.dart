import 'dart:nativewrappers/_internal/vm/bin/vmservice_io.dart' as AppError;

import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/safe_call.dart';
import 'package:super_fitness/features/meals/data/data_source/remote/meals_remote_data_source.dart';
import 'package:super_fitness/features/meals/data/mapper/meals_mapper.dart';
import 'package:super_fitness/features/meals/domain/entities/category_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/meals/domain/entities/meal_details_entity.dart';
import 'package:super_fitness/features/meals/domain/repo/meals_repo.dart';

@Injectable(as: MealsRepo)
class MealsRepoImpl implements MealsRepo {
  final MealsMapper _mealsMapper;
  final MealsRemoteDataSource _mealsRemoteDatasource;
  MealsRepoImpl(this._mealsMapper, this._mealsRemoteDatasource);

  @override
  Future<ApiResults<List<CategoryEntity>>> getCategories() async {
    return await safeCall<List<CategoryEntity>>(() async {
      final response = await _mealsRemoteDatasource.getCategories();

      return Success(
        _mealsMapper.mapCategoryListToEntityList(response.categories ?? []),
      );
    });
  }

  @override
  Future<ApiResults<List<MealEntity>>> getMealsByCategory(String category) async {
    return await safeCall<List<MealEntity>>(() async {
      final response = await _mealsRemoteDatasource.getMealsByCategory(
        category,
      );

      return Success(
        _mealsMapper.mapMealListToEntityList(response.meals ?? []),
      );
    });
  }

  @override
  Future<ApiResults<MealDetailsEntity>> getMealDetails(String mealId) async {
    return await safeCall<MealDetailsEntity>(() async {
      final response = await _mealsRemoteDatasource.getMealDetails(mealId);

      final meal = response.meals?.first;

      if (meal == null) {
        return Failure(ServerMessageFailure(AppError.server));
      }

      return Success(_mealsMapper.mapMealDetailsToEntity(meal));
    });
  }
}
