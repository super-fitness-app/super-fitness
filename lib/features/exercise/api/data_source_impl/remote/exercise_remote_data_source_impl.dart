import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';

@Injectable(as: ExerciseRemoteDataSource)
class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  const ExerciseRemoteDataSourceImpl();
}
