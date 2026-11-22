import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';

@injectable
class GetMuscleGroupsUseCase {
  final HomeRepo _homeRepo;

  const GetMuscleGroupsUseCase(this._homeRepo);

  Future<ApiResults<List<MuscleGroupEntity>>> call() {
    return _homeRepo.getMuscleGroups();
  }
}
