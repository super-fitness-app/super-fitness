import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_group_entity.dart';

abstract class ExerciseRemoteDataSource {
  Future<ApiResults<List<MuscleGroupEntity>>> getMuscleGroups();

  Future<ApiResults<List<MuscleEntity>>> getMusclesByGroup(String groupId);
}
