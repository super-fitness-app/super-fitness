import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';

@Injectable(as: ExerciseRepo)
class ExerciseRepoImpl implements ExerciseRepo {
  const ExerciseRepoImpl();
}
