import 'dart:math';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/home/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/home/domain/entities/popular_training_entity.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_popular_training_use_case.dart';

class FakePopularHomeRepo implements HomeRepo {
  List<DifficultyLevelEntity> levels = [
    const DifficultyLevelEntity(id: 'lvl1', name: 'Beginner'),
    const DifficultyLevelEntity(id: 'lvl2', name: 'Intermediate'),
    const DifficultyLevelEntity(id: 'lvl3', name: 'Advanced'),
    const DifficultyLevelEntity(id: 'lvl4', name: 'Novice'),
    const DifficultyLevelEntity(id: 'lvl5', name: 'Expert'),
  ];
  List<MuscleEntity> randomMuscles = [
    const MuscleEntity(id: 'm1', name: 'Pectoralis Major', imageUrl: 'https://pec.png'),
    const MuscleEntity(id: 'm2', name: 'Biceps', imageUrl: 'https://biceps.png'),
  ];
  List<PopularTrainingEntity> exercises = List.generate(
    10,
    (i) => PopularTrainingEntity(
      id: 'ex$i',
      title: 'Exercise $i',
      totalTasks: 20,
      levelText: 'Beginner',
      imageUrl: 'https://img$i.png',
    ),
  );

  bool failLevels = false;
  bool failMuscles = false;
  String? lastLevelId;
  String? lastMuscleId;

  @override
  Future<ApiResults<List<DifficultyLevelEntity>>> getDifficultyLevels() async {
    if (failLevels) return const Failure(ServerMessageFailure('Levels error'));
    return Success(levels);
  }

  @override
  Future<ApiResults<List<MuscleEntity>>> getRandomMuscles() async {
    if (failMuscles) return const Failure(ServerMessageFailure('Muscles error'));
    return Success(randomMuscles);
  }

  @override
  Future<ApiResults<List<PopularTrainingEntity>>> getExercisesByMuscleAndDifficulty({
    required String difficultyLevelId,
    required String primeMoverMuscleId,
    String? fallbackImageUrl,
    String? levelName,
  }) async {
    lastLevelId = difficultyLevelId;
    lastMuscleId = primeMoverMuscleId;
    return Success(exercises);
  }

  @override
  Future<ApiResults<List<MuscleGroupEntity>>> getMuscleGroups() async =>
      const Success([]);

  @override
  Future<ApiResults<List<MuscleEntity>>> getMusclesByMuscleGroupId(String id) async =>
      const Success([]);

  @override
  Future<ApiResults<List<MealCategoryEntity>>> getMealCategories() async =>
      const Success([]);
}

void main() {
  late FakePopularHomeRepo fakeRepo;
  late GetPopularTrainingUseCase useCase;

  setUp(() {
    fakeRepo = FakePopularHomeRepo();
    useCase = GetPopularTrainingUseCase(fakeRepo);
  });

  group('GetPopularTrainingUseCase Tests', () {
    test('fetches levels and muscles, picks random pair, and returns 3 to 5 exercises', () async {
      // Use seeded Random for deterministic testing
      final fixedRandom = Random(42);
      final result = await useCase(random: fixedRandom);

      expect(result, isA<Success<List<PopularTrainingEntity>>>());
      final data = (result as Success<List<PopularTrainingEntity>>).data;

      // Must be between 3 and 5 elements
      expect(data.length, inInclusiveRange(3, 5));

      // Verifies it called the API with the selected level and muscle
      expect(fakeRepo.lastLevelId, isNotNull);
      expect(fakeRepo.lastMuscleId, isNotNull);
      expect(
        ['lvl1', 'lvl2', 'lvl3', 'lvl4', 'lvl5'],
        contains(fakeRepo.lastLevelId),
      );
      expect(['m1', 'm2'], contains(fakeRepo.lastMuscleId));
    });

    test('ensures items in popular training have differing levels', () async {
      final fixedRandom = Random(42);
      final result = await useCase(random: fixedRandom);

      expect(result, isA<Success<List<PopularTrainingEntity>>>());
      final data = (result as Success<List<PopularTrainingEntity>>).data;

      final distinctLevels = data.map((e) => e.levelText).toSet();
      expect(distinctLevels.length, equals(data.length));
    });

    test('returns empty list when levels or muscles are empty', () async {
      fakeRepo.levels = [];
      final result = await useCase();

      expect(result, isA<Success<List<PopularTrainingEntity>>>());
      expect((result as Success<List<PopularTrainingEntity>>).data, isEmpty);
    });

    test('returns failure when getDifficultyLevels fails', () async {
      fakeRepo.failLevels = true;
      final result = await useCase();

      expect(result, isA<Failure<List<PopularTrainingEntity>>>());
    });

    test('returns failure when getRandomMuscles fails', () async {
      fakeRepo.failMuscles = true;
      final result = await useCase();

      expect(result, isA<Failure<List<PopularTrainingEntity>>>());
    });

    test('filters out exercises that have empty imageUrl', () async {
      fakeRepo.exercises = [
        const PopularTrainingEntity(
          id: 'ex1',
          title: 'Valid 1',
          totalTasks: 5,
          levelText: 'Beginner',
          imageUrl: 'https://valid1.png',
        ),
        const PopularTrainingEntity(
          id: 'ex2',
          title: 'No Image',
          totalTasks: 5,
          levelText: 'Beginner',
          imageUrl: '',
        ),
        const PopularTrainingEntity(
          id: 'ex3',
          title: 'Valid 2',
          totalTasks: 5,
          levelText: 'Beginner',
          imageUrl: 'https://valid2.png',
        ),
        const PopularTrainingEntity(
          id: 'ex4',
          title: 'Valid 3',
          totalTasks: 5,
          levelText: 'Beginner',
          imageUrl: 'https://valid3.png',
        ),
      ];

      final result = await useCase();
      expect(result, isA<Success<List<PopularTrainingEntity>>>());
      final data = (result as Success<List<PopularTrainingEntity>>).data;
      expect(data.every((e) => e.imageUrl.isNotEmpty), isTrue);
      expect(data.any((e) => e.id == 'ex2'), isFalse);
    });
  });
}
