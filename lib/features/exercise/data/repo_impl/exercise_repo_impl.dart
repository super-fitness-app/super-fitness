import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/safe_call.dart';
import 'package:super_fitness/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';
import 'package:super_fitness/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/exercise_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';

@Injectable(as: ExerciseRepo)
class ExerciseRepoImpl implements ExerciseRepo {
  final ExerciseRemoteDataSource _exerciseRemoteDataSource;

  ExerciseRepoImpl(this._exerciseRemoteDataSource);

  @override
  Future<ApiResults<List<DifficultyLevelEntity>>> getAllDifficultyLevels({
    required String language,
  }) {
    return safeCall(() async {
      final response = await _exerciseRemoteDataSource.getAllDifficultyLevels(
        language: language,
      );
      return Success(response.levels.map((e) => e.toEntity()).toList());
    });
  }

  @override
  Future<ApiResults<List<MuscleEntity>>> getMusclesByGroup(
    String muscleGroupId,
  ) {
    return safeCall(() async {
      final response = await _exerciseRemoteDataSource.getMusclesByGroup(
        muscleGroupId: muscleGroupId,
      );
      return Success(response.muscles.map((e) => e.toEntity()).toList());
    });
  }

  @override
  Future<ApiResults<List<ExerciseEntity>>> getExercisesByMuscleAndDifficulty({
    required String language,
    required String difficultyLevelId,
    required String primeMoverMuscleId,
  }) {
    return safeCall(() async {
      final response = await _exerciseRemoteDataSource
          .getExercisesByMuscleAndDifficulty(
            language: language,
            difficultyLevelId: difficultyLevelId,
            primeMoverMuscleId: primeMoverMuscleId,
          );
      return Success(response.exercises.map((e) => e.toEntity()).toList());
    });
  }
}
