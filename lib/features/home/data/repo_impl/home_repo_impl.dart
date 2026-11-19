import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/safe_call.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:super_fitness/features/home/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/home/domain/entities/popular_training_entity.dart';
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
      final response = await _homeRemoteDataSource.getRandomMuscles().timeout(
        const Duration(seconds: 8),
      );
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
      final unseen = list.where((m) => !previousIds.contains(m.id)).toList()
        ..shuffle();
      final seen = list.where((m) => previousIds.contains(m.id)).toList()
        ..shuffle();

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
      final response = await _homeRemoteDataSource.getMuscleGroups().timeout(
        const Duration(seconds: 8),
      );
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
      final response = await _homeRemoteDataSource.getMealCategories().timeout(
        const Duration(seconds: 4),
      );
      final list = response.categories?.map((e) => e.toEntity()).toList() ?? [];
      return Success(list);
    });
  }

  @override
  Future<ApiResults<List<DifficultyLevelEntity>>> getDifficultyLevels() {
    return safeCall<List<DifficultyLevelEntity>>(() async {
      final response = await _homeRemoteDataSource
          .getDifficultyLevels()
          .timeout(const Duration(seconds: 8));
      final list = response.levels?.map((e) => e.toEntity()).toList() ?? [];
      return Success(list);
    });
  }

  @override
  Future<ApiResults<List<PopularTrainingEntity>>>
  getExercisesByMuscleAndDifficulty({
    required String difficultyLevelId,
    required String primeMoverMuscleId,
    String? fallbackImageUrl,
    String? levelName,
  }) {
    return safeCall<List<PopularTrainingEntity>>(() async {
      final response = await _homeRemoteDataSource
          .getExercisesByMuscleAndDifficulty(
            difficultyLevelId: difficultyLevelId,
            primeMoverMuscleId: primeMoverMuscleId,
          )
          .timeout(const Duration(seconds: 8));

      final exercises = response.exercises ?? [];
      final total = response.totalExercises ?? exercises.length;

      final list = exercises
          .map((e) {
            final rawImage = (e.image != null && e.image!.trim().isNotEmpty)
                ? e.image!.trim()
                : null;
            final ytThumb = _extractYoutubeThumbnail(
              e.shortYoutubeDemonstrationLink,
            );
            final img = rawImage ?? ytThumb ?? fallbackImageUrl;

            // If item image is null or empty, do not show this item
            if (img == null || img.trim().isEmpty) {
              return null;
            }

            return PopularTrainingEntity(
              id: e.id ?? '',
              title: e.exercise?.trim() ?? '',
              totalTasks: total,
              levelText: e.difficultyLevel?.trim() ?? levelName ?? 'Beginner',
              imageUrl: img.trim(),
              videoUrl: e.shortYoutubeDemonstrationLink,
            );
          })
          .whereType<PopularTrainingEntity>()
          .toList();

      return Success(list);
    });
  }

  static String? _extractYoutubeThumbnail(String? url) {
    if (url == null || url.trim().isEmpty) return null;
    try {
      final uri = Uri.tryParse(url.trim());
      if (uri == null) return null;
      String? videoId;
      if (uri.host.contains('youtu.be')) {
        videoId = uri.pathSegments.isNotEmpty ? uri.pathSegments.first : null;
      } else if (uri.host.contains('youtube.com')) {
        if (uri.pathSegments.contains('shorts')) {
          final idx = uri.pathSegments.indexOf('shorts');
          if (idx + 1 < uri.pathSegments.length) {
            videoId = uri.pathSegments[idx + 1];
          }
        } else if (uri.pathSegments.contains('embed')) {
          final idx = uri.pathSegments.indexOf('embed');
          if (idx + 1 < uri.pathSegments.length) {
            videoId = uri.pathSegments[idx + 1];
          }
        } else {
          videoId = uri.queryParameters['v'];
        }
      }
      if (videoId != null && videoId.isNotEmpty) {
        return 'https://img.youtube.com/vi/$videoId/hqdefault.jpg';
      }
    } catch (_) {}
    return null;
  }
}
