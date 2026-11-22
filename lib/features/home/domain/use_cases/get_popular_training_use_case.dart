import 'dart:math';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/home/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/entities/popular_training_entity.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';

@injectable
class GetPopularTrainingUseCase {
  final HomeRepo _homeRepo;

  const GetPopularTrainingUseCase(this._homeRepo);

  Future<ApiResults<List<PopularTrainingEntity>>> call({Random? random}) async {
    final rng = random ?? Random();

    // 1. Fetch Difficulty Levels & 20 Random Prime Mover Muscles
    final levelsFuture = _homeRepo.getDifficultyLevels();
    final musclesFuture = _homeRepo.getRandomMuscles();

    final results = await Future.wait([levelsFuture, musclesFuture]);
    final levelsResult = results[0] as ApiResults<List<DifficultyLevelEntity>>;
    final musclesResult = results[1] as ApiResults<List<MuscleEntity>>;

    if (levelsResult is! Success<List<DifficultyLevelEntity>> ||
        musclesResult is! Success<List<MuscleEntity>>) {
      return const Failure(
        ServerMessageFailure('Failed to load popular training data'),
      );
    }

    final levels = levelsResult.data;
    final muscles = musclesResult.data
        .where((m) => m.imageUrl.trim().isNotEmpty)
        .toList();

    if (levels.isEmpty || muscles.isEmpty) {
      return const Success([]);
    }

    final shuffledLevels = List<DifficultyLevelEntity>.from(levels)
      ..shuffle(rng);
    final shuffledMuscles = List<MuscleEntity>.from(muscles)..shuffle(rng);

    // 2. Select distinct random levels for items to make them differ from one another
    final targetCount = (rng.nextInt(3) + 3).clamp(3, 5);
    final distinctLevels = shuffledLevels.take(targetCount).toList();
    final tasks = <Future<ApiResults<List<PopularTrainingEntity>>>>[];

    for (int i = 0; i < distinctLevels.length; i++) {
      final lvl = distinctLevels[i];
      final m = shuffledMuscles[i % shuffledMuscles.length];
      tasks.add(
        _homeRepo.getExercisesByMuscleAndDifficulty(
          difficultyLevelId: lvl.id,
          primeMoverMuscleId: m.id,
          levelName: lvl.name,
        ),
      );
    }

    final resultsList = await Future.wait(tasks);

    final selectedExercises = <PopularTrainingEntity>[];
    final remainingPool = <PopularTrainingEntity>[];

    for (final res in resultsList) {
      if (res is Success<List<PopularTrainingEntity>>) {
        final validList =
            res.data.where((e) => e.imageUrl.trim().isNotEmpty).toList()
              ..shuffle(rng);
        if (validList.isNotEmpty) {
          selectedExercises.add(validList.first);
          if (validList.length > 1) {
            remainingPool.addAll(validList.skip(1));
          }
        }
      }
    }

    // If some distinct level calls returned 0 exercises, fill from remainingPool
    if (selectedExercises.length < targetCount && remainingPool.isNotEmpty) {
      remainingPool.shuffle(rng);
      for (final extra in remainingPool) {
        if (selectedExercises.length >= targetCount) break;
        if (!selectedExercises.any((e) => e.id == extra.id)) {
          selectedExercises.add(extra);
        }
      }
    }

    // Fallback: If still empty, try sequential fallback combinations
    if (selectedExercises.isEmpty) {
      for (int i = 0; i < min(3, shuffledMuscles.length); i++) {
        final selectedLevel = shuffledLevels[i % shuffledLevels.length];
        final selectedMuscle = shuffledMuscles[i];

        final exercisesResult = await _homeRepo
            .getExercisesByMuscleAndDifficulty(
              difficultyLevelId: selectedLevel.id,
              primeMoverMuscleId: selectedMuscle.id,
              levelName: selectedLevel.name,
            );

        if (exercisesResult is Success<List<PopularTrainingEntity>>) {
          final exercises = exercisesResult.data
              .where((e) => e.imageUrl.trim().isNotEmpty)
              .toList();
          if (exercises.isNotEmpty) {
            exercises.shuffle(rng);
            selectedExercises.addAll(
              exercises.take(min(targetCount, exercises.length)),
            );
            break;
          }
        }
      }
    }

    if (selectedExercises.isEmpty) {
      return const Success([]);
    }

    // 3. Ensure each item has a distinct random level to differ from one another
    final availableLevelNames = shuffledLevels.map((l) => l.name).toList();
    final usedLevels = <String>{};
    final finalItems = <PopularTrainingEntity>[];

    for (int i = 0; i < selectedExercises.length; i++) {
      final ex = selectedExercises[i];
      String level = ex.levelText.trim();
      if (level.isEmpty || usedLevels.contains(level)) {
        final unused = availableLevelNames
            .where((l) => !usedLevels.contains(l))
            .toList();
        level = unused.isNotEmpty
            ? unused.first
            : availableLevelNames[i % availableLevelNames.length];
      }
      usedLevels.add(level);
      finalItems.add(ex.copyWith(levelText: level));
    }

    return Success(finalItems);
  }
}
