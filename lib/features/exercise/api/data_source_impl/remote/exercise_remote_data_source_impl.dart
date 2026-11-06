import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/safe_call.dart';
import 'package:super_fitness/features/exercise/api/client/exercise_api_client.dart';
import 'package:super_fitness/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_group_entity.dart';

@Injectable(as: ExerciseRemoteDataSource)
class ExerciseRemoteDataSourceImpl implements ExerciseRemoteDataSource {
  final ExerciseApiClient _exerciseApiClient;

  ExerciseRemoteDataSourceImpl(this._exerciseApiClient);

  @override
  Future<ApiResults<List<MuscleGroupEntity>>> getMuscleGroups() =>
      safeCall(() async {
        final response = await _exerciseApiClient.getMuscleGroups();
        final entities =
            response.musclesGroup
                ?.where((m) => m.id != null && m.name != null)
                .map((m) => m.toEntity())
                .toList() ??
            [];
        return Success(entities);
      });

  @override
  Future<ApiResults<List<MuscleEntity>>> getMusclesByGroup(String groupId) =>
      safeCall(() async {
        final response = await _exerciseApiClient.getMusclesByGroup(groupId);
        final entities =
            response.muscles
                ?.where((m) => m.id != null && m.name != null)
                .map((m) => m.toEntity())
                .toList() ??
            [];
        return Success(entities);
      });
}
