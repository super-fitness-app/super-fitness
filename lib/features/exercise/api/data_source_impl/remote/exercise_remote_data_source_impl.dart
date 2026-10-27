import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/exercise/api/client/exercise_api_client.dart';
import 'package:super_fitness/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';

@Injectable(as: ExerciseRemoteDataSource)
class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final ExerciseApiClient _exerciseApiClient;

  ExerciseRemoteDataSourceImpl(this._exerciseApiClient);
}

