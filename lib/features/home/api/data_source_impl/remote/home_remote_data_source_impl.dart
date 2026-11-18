import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/home/api/client/home_api_client.dart';
import 'package:super_fitness/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:super_fitness/features/home/data/models/meal_categories_response_dto.dart';
import 'package:super_fitness/features/home/data/models/muscle_groups_response_dto.dart';
import 'package:super_fitness/features/home/data/models/muscles_by_group_response_dto.dart';
import 'package:super_fitness/features/home/data/models/random_muscles_response_dto.dart';

@Injectable(as: HomeRemoteDataSource)
class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final HomeApiClient _homeApiClient;

  HomeRemoteDataSourceImpl(this._homeApiClient);

  @override
  Future<RandomMusclesResponseDto> getRandomMuscles() {
    return _homeApiClient.getRandomMuscles();
  }

  @override
  Future<MuscleGroupsResponseDto> getMuscleGroups() {
    return _homeApiClient.getMuscleGroups();
  }

  @override
  Future<MusclesByGroupResponseDto> getMusclesByMuscleGroupId(String id) {
    return _homeApiClient.getMusclesByMuscleGroupId(id);
  }

  @override
  Future<MealCategoriesResponseDto> getMealCategories() {
    return _homeApiClient.getMealCategories();
  }
}
