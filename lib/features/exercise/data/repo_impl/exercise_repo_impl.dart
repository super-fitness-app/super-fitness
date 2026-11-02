import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';

@Injectable(as: ExerciseRepo)
class ExerciseRepoImpl implements ExerciseRepo {
  final ExerciseRemoteDataSource _exerciseRemoteDataSource;

  ExerciseRepoImpl(this._exerciseRemoteDataSource);

  @override
  Future<ApiResults<List<MuscleGroupEntity>>> getMuscleGroups() =>
      _exerciseRemoteDataSource.getMuscleGroups();

  @override
  Future<ApiResults<List<MuscleEntity>>> getMusclesByGroup(String groupId) =>
      _exerciseRemoteDataSource.getMusclesByGroup(groupId);
}
