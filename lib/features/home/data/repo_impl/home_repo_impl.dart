import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/safe_call.dart';
import 'package:super_fitness/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';

@Injectable(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  final HomeRemoteDataSource _homeRemoteDataSource;

  HomeRepoImpl(this._homeRemoteDataSource);

  @override
  Future<ApiResults<List<MuscleEntity>>> getRandomMuscles() {
    return safeCall<List<MuscleEntity>>(() async {
      final response = await _homeRemoteDataSource.getRandomMuscles();
      final list = response.muscles?.map((e) => e.toEntity()).toList() ?? [];
      return Success(list);
    });
  }

  @override
  Future<ApiResults<List<MuscleGroupEntity>>> getMuscleGroups() {
    return safeCall<List<MuscleGroupEntity>>(() async {
      final response = await _homeRemoteDataSource.getMuscleGroups();
      final list =
          response.musclesGroup?.map((e) => e.toEntity()).toList() ?? [];
      return Success(list);
    });
  }

  @override
  Future<ApiResults<List<MuscleEntity>>> getMusclesByMuscleGroupId(String id) {
    return safeCall<List<MuscleEntity>>(() async {
      final response = await _homeRemoteDataSource.getMusclesByMuscleGroupId(
        id,
      );
      final list = response.muscles?.map((e) => e.toEntity()).toList() ?? [];
      return Success(list);
    });
  }

  @override
  Future<ApiResults<List<MealCategoryEntity>>> getMealCategories() {
    return safeCall<List<MealCategoryEntity>>(() async {
      final response = await _homeRemoteDataSource.getMealCategories();
      final list = response.categories?.map((e) => e.toEntity()).toList() ?? [];
      return Success(list);
    });
  }
}
