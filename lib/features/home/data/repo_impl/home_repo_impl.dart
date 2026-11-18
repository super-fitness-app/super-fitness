import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/safe_call.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';

@Injectable(as: HomeRepo)
class HomeRepoImpl implements HomeRepo {
  static const String _lastRecommendationIdsKey =
      'last_recommendation_muscle_ids';

  final HomeRemoteDataSource _homeRemoteDataSource;
  final StorageService? _storageService;

  HomeRepoImpl(this._homeRemoteDataSource, [this._storageService]);

  @override
  Future<ApiResults<List<MuscleEntity>>> getRandomMuscles() {
    return safeCall<List<MuscleEntity>>(() async {
      final response = await _homeRemoteDataSource
          .getRandomMuscles()
          .timeout(const Duration(seconds: 8));
      final list =
          response.muscles
              ?.where((e) => e.image != null && e.image!.trim().isNotEmpty)
              .map((e) => e.toEntity())
              .toList() ??
          [];

      if (list.isEmpty) {
        return const Success([]);
      }

      Set<String> previousIds = {};
      try {
        if (_storageService != null) {
          final stored = await _storageService.get(_lastRecommendationIdsKey);
          if (stored.isNotEmpty) {
            previousIds = stored.split(',').where((s) => s.isNotEmpty).toSet();
          }
        }
      } catch (_) {}

      // Prioritize unseen muscles to guarantee fresh recommendation on every app restart
      final unseen =
          list.where((m) => !previousIds.contains(m.id)).toList()..shuffle();
      final seen =
          list.where((m) => previousIds.contains(m.id)).toList()..shuffle();

      final selected = [...unseen, ...seen].take(6).toList();

      try {
        if (_storageService != null && selected.isNotEmpty) {
          await _storageService.save(
            _lastRecommendationIdsKey,
            selected.map((m) => m.id).join(','),
          );
        }
      } catch (_) {}

      return Success(selected);
    });
  }

  @override
  Future<ApiResults<List<MuscleGroupEntity>>> getMuscleGroups() {
    return safeCall<List<MuscleGroupEntity>>(() async {
      final response = await _homeRemoteDataSource
          .getMuscleGroups()
          .timeout(const Duration(seconds: 8));
      final list =
          response.musclesGroup?.map((e) => e.toEntity()).toList() ?? [];
      return Success(list);
    });
  }

  @override
  Future<ApiResults<List<MuscleEntity>>> getMusclesByMuscleGroupId(String id) {
    return safeCall<List<MuscleEntity>>(() async {
      final response = await _homeRemoteDataSource
          .getMusclesByMuscleGroupId(id)
          .timeout(const Duration(seconds: 8));
      final list = response.muscles?.map((e) => e.toEntity()).toList() ?? [];
      return Success(list);
    });
  }

  @override
  Future<ApiResults<List<MealCategoryEntity>>> getMealCategories() {
    return safeCall<List<MealCategoryEntity>>(() async {
      final response = await _homeRemoteDataSource
          .getMealCategories()
          .timeout(const Duration(seconds: 4));
      final list = response.categories?.map((e) => e.toEntity()).toList() ?? [];
      return Success(list);
    });
  }
}
