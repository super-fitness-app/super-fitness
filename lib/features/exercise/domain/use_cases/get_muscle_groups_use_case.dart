import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';

@injectable
class GetMuscleGroupsUseCase {
  final ExerciseRepo _repo;

  GetMuscleGroupsUseCase(this._repo);

  Future<ApiResults<List<MuscleGroupEntity>>> call() => _repo.getMuscleGroups();
}
