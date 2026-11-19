import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/home/api/client/home_api_client.dart';
import 'package:super_fitness/features/home/api/data_source_impl/remote/home_remote_data_source_impl.dart';
import 'package:super_fitness/features/home/data/models/difficulty_level_dto.dart';
import 'package:super_fitness/features/home/data/models/difficulty_levels_response_dto.dart';
import 'package:super_fitness/features/home/data/models/exercises_by_muscle_difficulty_response_dto.dart';
import 'package:super_fitness/features/home/data/models/meal_categories_response_dto.dart';
import 'package:super_fitness/features/home/data/models/meal_category_dto.dart';
import 'package:super_fitness/features/home/data/models/muscle_dto.dart';
import 'package:super_fitness/features/home/data/models/muscle_group_dto.dart';
import 'package:super_fitness/features/home/data/models/muscle_groups_response_dto.dart';
import 'package:super_fitness/features/home/data/models/muscles_by_group_response_dto.dart';
import 'package:super_fitness/features/home/data/models/popular_exercise_dto.dart';
import 'package:super_fitness/features/home/data/models/random_muscles_response_dto.dart';

class FakeHomeApiClient implements HomeApiClient {
  RandomMusclesResponseDto? randomMusclesResponse;
  MuscleGroupsResponseDto? muscleGroupsResponse;
  MusclesByGroupResponseDto? musclesByGroupResponse;
  MealCategoriesResponseDto? mealCategoriesResponse;
  DifficultyLevelsResponseDto? difficultyLevelsResponse;
  ExercisesByMuscleDifficultyResponseDto? exercisesByMuscleDifficultyResponse;
  Exception? errorToThrow;

  @override
  Future<RandomMusclesResponseDto> getRandomMuscles() async {
    if (errorToThrow != null) throw errorToThrow!;
    return randomMusclesResponse ??
        const RandomMusclesResponseDto(message: 'success', muscles: []);
  }

  @override
  Future<MuscleGroupsResponseDto> getMuscleGroups() async {
    if (errorToThrow != null) throw errorToThrow!;
    return muscleGroupsResponse ??
        const MuscleGroupsResponseDto(message: 'success', musclesGroup: []);
  }

  @override
  Future<MusclesByGroupResponseDto> getMusclesByMuscleGroupId(String id) async {
    if (errorToThrow != null) throw errorToThrow!;
    return musclesByGroupResponse ??
        const MusclesByGroupResponseDto(message: 'success', muscles: []);
  }

  @override
  Future<MealCategoriesResponseDto> getMealCategories() async {
    if (errorToThrow != null) throw errorToThrow!;
    return mealCategoriesResponse ??
        const MealCategoriesResponseDto(categories: []);
  }

  @override
  Future<DifficultyLevelsResponseDto> getDifficultyLevels() async {
    if (errorToThrow != null) throw errorToThrow!;
    return difficultyLevelsResponse ??
        const DifficultyLevelsResponseDto(message: 'success', levels: []);
  }

  @override
  Future<ExercisesByMuscleDifficultyResponseDto> getExercisesByMuscleAndDifficulty(
    String difficultyLevelId,
    String primeMoverMuscleId,
  ) async {
    if (errorToThrow != null) throw errorToThrow!;
    return exercisesByMuscleDifficultyResponse ??
        const ExercisesByMuscleDifficultyResponseDto(message: 'success', exercises: []);
  }
}

void main() {
  late FakeHomeApiClient fakeApiClient;
  late HomeRemoteDataSourceImpl remoteDataSource;

  setUp(() {
    fakeApiClient = FakeHomeApiClient();
    remoteDataSource = HomeRemoteDataSourceImpl(fakeApiClient);
  });

  group('HomeRemoteDataSourceImpl Unit Tests', () {
    test('getRandomMuscles calls client.getRandomMuscles and returns response', () async {
      const expectedResponse = RandomMusclesResponseDto(
        message: 'success',
        totalMuscles: 1,
        muscles: [
          MuscleDto(id: 'm1', name: 'Biceps', image: 'https://biceps.png'),
        ],
      );
      fakeApiClient.randomMusclesResponse = expectedResponse;

      final result = await remoteDataSource.getRandomMuscles();

      expect(result.message, 'success');
      expect(result.muscles?.length, 1);
      expect(result.muscles?.first.name, 'Biceps');
    });

    test('getMuscleGroups calls client.getMuscleGroups and returns response', () async {
      const expectedResponse = MuscleGroupsResponseDto(
        message: 'success',
        musclesGroup: [MuscleGroupDto(id: 'g1', name: 'Chest')],
      );
      fakeApiClient.muscleGroupsResponse = expectedResponse;

      final result = await remoteDataSource.getMuscleGroups();

      expect(result.message, 'success');
      expect(result.musclesGroup?.length, 1);
      expect(result.musclesGroup?.first.name, 'Chest');
    });

    test('getMusclesByMuscleGroupId calls client.getMusclesByMuscleGroupId and returns response', () async {
      const expectedResponse = MusclesByGroupResponseDto(
        message: 'success',
        muscles: [
          MuscleDto(id: 'm2', name: 'Pectoralis', image: 'https://pec.png'),
        ],
      );
      fakeApiClient.musclesByGroupResponse = expectedResponse;

      final result = await remoteDataSource.getMusclesByMuscleGroupId('g1');

      expect(result.message, 'success');
      expect(result.muscles?.length, 1);
      expect(result.muscles?.first.name, 'Pectoralis');
    });

    test('getMealCategories calls client.getMealCategories and returns response', () async {
      const expectedResponse = MealCategoriesResponseDto(
        categories: [
          MealCategoryDto(
            idCategory: 'c1',
            strCategory: 'Beef',
            strCategoryThumb: 'https://beef.png',
            strCategoryDescription: 'Beef meals',
          ),
        ],
      );
      fakeApiClient.mealCategoriesResponse = expectedResponse;

      final result = await remoteDataSource.getMealCategories();

      expect(result.categories?.length, 1);
      expect(result.categories?.first.strCategory, 'Beef');
    });

    test('getDifficultyLevels calls client.getDifficultyLevels and returns response', () async {
      const expectedResponse = DifficultyLevelsResponseDto(
        message: 'success',
        levels: [DifficultyLevelDto(id: 'lvl1', name: 'Novice')],
      );
      fakeApiClient.difficultyLevelsResponse = expectedResponse;

      final result = await remoteDataSource.getDifficultyLevels();

      expect(result.levels?.length, 1);
      expect(result.levels?.first.name, 'Novice');
    });

    test('getExercisesByMuscleAndDifficulty calls client and returns response', () async {
      const expectedResponse = ExercisesByMuscleDifficultyResponseDto(
        message: 'success',
        totalExercises: 5,
        exercises: [
          PopularExerciseDto(
            id: 'ex1',
            exercise: 'Push-up',
            difficultyLevel: 'Novice',
          ),
        ],
      );
      fakeApiClient.exercisesByMuscleDifficultyResponse = expectedResponse;

      final result = await remoteDataSource.getExercisesByMuscleAndDifficulty(
        difficultyLevelId: 'lvl1',
        primeMoverMuscleId: 'm1',
      );

      expect(result.totalExercises, 5);
      expect(result.exercises?.first.exercise, 'Push-up');
    });

    test('rethrows exception when client throws', () async {
      fakeApiClient.errorToThrow = Exception('Network error');

      expect(
        () => remoteDataSource.getRandomMuscles(),
        throwsA(isA<Exception>()),
      );
      expect(
        () => remoteDataSource.getMuscleGroups(),
        throwsA(isA<Exception>()),
      );
      expect(
        () => remoteDataSource.getMusclesByMuscleGroupId('1'),
        throwsA(isA<Exception>()),
      );
      expect(
        () => remoteDataSource.getMealCategories(),
        throwsA(isA<Exception>()),
      );
      expect(
        () => remoteDataSource.getDifficultyLevels(),
        throwsA(isA<Exception>()),
      );
      expect(
        () => remoteDataSource.getExercisesByMuscleAndDifficulty(
          difficultyLevelId: '1',
          primeMoverMuscleId: '1',
        ),
        throwsA(isA<Exception>()),
      );
    });
  });
}
