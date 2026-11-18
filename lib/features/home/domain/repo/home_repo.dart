import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';

abstract class HomeRepo {
  Future<ApiResults<List<MuscleEntity>>> getRandomMuscles();
  Future<ApiResults<List<MuscleGroupEntity>>> getMuscleGroups();
  Future<ApiResults<List<MuscleEntity>>> getMusclesByMuscleGroupId(String id);
  Future<ApiResults<List<MealCategoryEntity>>> getMealCategories();
}
