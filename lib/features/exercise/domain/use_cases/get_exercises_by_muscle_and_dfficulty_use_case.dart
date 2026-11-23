import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/domain/entities/exercise_entity.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';

@injectable
class GetExercisesByMuscleAndDfficultyUseCase {
  final ExerciseRepo _exerciseRepo;

  GetExercisesByMuscleAndDfficultyUseCase(this._exerciseRepo);

  Future<ApiResults<List<ExerciseEntity>>> call({
    required String language,
    required String difficultyLevelId,
    required String primeMoverMuscleId,
  }) {
    return _exerciseRepo.getExercisesByMuscleAndDifficulty(
      language: language,
      difficultyLevelId: difficultyLevelId,
      primeMoverMuscleId: primeMoverMuscleId,
    );
  }
}
