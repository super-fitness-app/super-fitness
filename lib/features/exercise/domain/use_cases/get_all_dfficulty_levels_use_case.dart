import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';

@injectable
class GetAllDfficultyLevelsUseCase {
  final ExerciseRepo _exerciseRepo;

  GetAllDfficultyLevelsUseCase(this._exerciseRepo);

  Future<ApiResults<List<DifficultyLevelEntity>>> call({
    required String language,
  }) {
    return _exerciseRepo.getAllDifficultyLevels(language: language);
  }
}
