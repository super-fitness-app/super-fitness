import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';

@injectable
class GetMusclesByGroupUseCase {
  final ExerciseRepo _repo;

  GetMusclesByGroupUseCase(this._repo);

  Future<ApiResults<List<MuscleEntity>>> call(String groupId) =>
      _repo.getMusclesByGroup(groupId);
}
