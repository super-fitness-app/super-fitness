import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';

@injectable
class GetAllMusclesUseCase {
  final ExerciseRepo _exerciseRepo;

  GetAllMusclesUseCase(this._exerciseRepo);

  Future<ApiResults<List<MuscleEntity>>> call({required String muscleGroupId}) {
    return _exerciseRepo.getMusclesByGroup(muscleGroupId);
  }
}
