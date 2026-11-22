import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';

@injectable
class GetRandomMusclesUseCase {
  final HomeRepo _homeRepo;

  const GetRandomMusclesUseCase(this._homeRepo);

  Future<ApiResults<List<MuscleEntity>>> call() {
    return _homeRepo.getRandomMuscles();
  }
}
