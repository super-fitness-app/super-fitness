import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';

@Injectable(as: ExerciseRepo)
class ExerciseRepoImpl implements ExerciseRepo {
  final ExerciseRemoteDataSource _exerciseRemoteDataSource;

  ExerciseRepoImpl(this._exerciseRemoteDataSource);
}

