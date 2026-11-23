import 'package:super_fitness/features/home/data/models/difficulty_levels_response_dto.dart';
import 'package:super_fitness/features/home/data/models/exercises_by_muscle_difficulty_response_dto.dart';
import 'package:super_fitness/features/home/data/models/meal_categories_response_dto.dart';
import 'package:super_fitness/features/home/data/models/muscle_groups_response_dto.dart';
import 'package:super_fitness/features/home/data/models/muscles_by_group_response_dto.dart';
import 'package:super_fitness/features/home/data/models/random_muscles_response_dto.dart';

abstract class HomeRemoteDataSource {
  Future<RandomMusclesResponseDto> getRandomMuscles();
  Future<MuscleGroupsResponseDto> getMuscleGroups();
  Future<MusclesByGroupResponseDto> getMusclesByMuscleGroupId(String id);
  Future<MealCategoriesResponseDto> getMealCategories();
  Future<DifficultyLevelsResponseDto> getDifficultyLevels();
  Future<ExercisesByMuscleDifficultyResponseDto>
  getExercisesByMuscleAndDifficulty({
    required String difficultyLevelId,
    required String primeMoverMuscleId,
  });
}
