import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/home/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/home/domain/entities/popular_training_entity.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_meal_categories_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_random_muscles_use_case.dart';

class FakeHomeRepo implements HomeRepo {
  ApiResults<List<MuscleEntity>> randomMusclesResult = const Success([]);
  ApiResults<List<MuscleGroupEntity>> muscleGroupsResult = const Success([]);
  ApiResults<List<MuscleEntity>> musclesByGroupResult = const Success([]);
  ApiResults<List<MealCategoryEntity>> mealCategoriesResult = const Success([]);
  ApiResults<List<DifficultyLevelEntity>> difficultyLevelsResult =
      const Success([]);
  ApiResults<List<PopularTrainingEntity>> exercisesResult = const Success([]);

  String? lastMusclesByGroupId;

  @override
  Future<ApiResults<List<MuscleEntity>>> getRandomMuscles() async {
    return randomMusclesResult;
  }

  @override
  Future<ApiResults<List<MuscleGroupEntity>>> getMuscleGroups() async {
    return muscleGroupsResult;
  }

  @override
  Future<ApiResults<List<MuscleEntity>>> getMusclesByMuscleGroupId(String id) async {
    lastMusclesByGroupId = id;
    return musclesByGroupResult;
  }

  @override
  Future<ApiResults<List<MealCategoryEntity>>> getMealCategories() async {
    return mealCategoriesResult;
  }

  @override
  Future<ApiResults<List<DifficultyLevelEntity>>> getDifficultyLevels() async {
    return difficultyLevelsResult;
  }

  @override
  Future<ApiResults<List<PopularTrainingEntity>>>
      getExercisesByMuscleAndDifficulty({
    required String difficultyLevelId,
    required String primeMoverMuscleId,
    String? fallbackImageUrl,
    String? levelName,
  }) async {
    return exercisesResult;
  }
}

void main() {
  late FakeHomeRepo fakeRepo;

  setUp(() {
    fakeRepo = FakeHomeRepo();
  });

  group('Home Domain Use Cases Tests', () {
    test('GetRandomMusclesUseCase calls repo.getRandomMuscles()', () async {
      const expectedMuscles = [
        MuscleEntity(id: 'm1', name: 'Deltoid', imageUrl: 'https://img.png'),
      ];
      fakeRepo.randomMusclesResult = const Success(expectedMuscles);

      final useCase = GetRandomMusclesUseCase(fakeRepo);
      final result = await useCase();

      expect(result, isA<Success<List<MuscleEntity>>>());
      expect((result as Success<List<MuscleEntity>>).data, expectedMuscles);
    });

    test('GetMuscleGroupsUseCase calls repo.getMuscleGroups()', () async {
      const expectedGroups = [
        MuscleGroupEntity(id: 'g1', name: 'Shoulders'),
      ];
      fakeRepo.muscleGroupsResult = const Success(expectedGroups);

      final useCase = GetMuscleGroupsUseCase(fakeRepo);
      final result = await useCase();

      expect(result, isA<Success<List<MuscleGroupEntity>>>());
      expect((result as Success<List<MuscleGroupEntity>>).data, expectedGroups);
    });

    test('GetMusclesByGroupUseCase calls repo.getMusclesByMuscleGroupId with target id', () async {
      const expectedMuscles = [
        MuscleEntity(id: 'm2', name: 'Front Delt', imageUrl: 'https://f.png'),
      ];
      fakeRepo.musclesByGroupResult = const Success(expectedMuscles);

      final useCase = GetMusclesByGroupUseCase(fakeRepo);
      final result = await useCase('g1');

      expect(fakeRepo.lastMusclesByGroupId, 'g1');
      expect(result, isA<Success<List<MuscleEntity>>>());
      expect((result as Success<List<MuscleEntity>>).data, expectedMuscles);
    });

    test('GetMealCategoriesUseCase calls repo.getMealCategories()', () async {
      const expectedCategories = [
        MealCategoryEntity(
          id: 'c1',
          name: 'Seafood',
          thumbnailUrl: 'https://sea.png',
          description: 'Fish and crab',
        ),
      ];
      fakeRepo.mealCategoriesResult = const Success(expectedCategories);

      final useCase = GetMealCategoriesUseCase(fakeRepo);
      final result = await useCase();

      expect(result, isA<Success<List<MealCategoryEntity>>>());
      expect(
        (result as Success<List<MealCategoryEntity>>).data,
        expectedCategories,
      );
    });
  });
}
