import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/core/const/app_colors.dart';
import 'package:super_fitness/features/home/data/models/difficulty_level_dto.dart';
import 'package:super_fitness/features/home/data/models/difficulty_levels_response_dto.dart';
import 'package:super_fitness/features/home/data/models/exercises_by_muscle_difficulty_response_dto.dart';
import 'package:super_fitness/features/home/data/models/meal_categories_response_dto.dart';
import 'package:super_fitness/features/home/data/models/meal_category_dto.dart';
import 'package:super_fitness/features/home/data/models/muscle_dto.dart';
import 'package:super_fitness/features/home/data/models/muscle_group_dto.dart';
import 'package:super_fitness/features/home/data/models/muscle_groups_response_dto.dart';
import 'package:super_fitness/features/home/data/models/muscles_by_group_response_dto.dart';
import 'package:super_fitness/features/home/data/models/popular_exercise_dto.dart';
import 'package:super_fitness/features/home/data/models/random_muscles_response_dto.dart';
import 'package:super_fitness/features/home/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/home/domain/entities/popular_training_entity.dart';

void main() {
  group('Home Models & Entities Unit Tests', () {
    group('MuscleDto', () {
      test('fromJson and toJson work correctly', () {
        final json = {
          '_id': 'm100',
          'name': 'Biceps',
          'image': 'https://image.com/biceps.png',
        };

        final dto = MuscleDto.fromJson(json);

        expect(dto.id, 'm100');
        expect(dto.name, 'Biceps');
        expect(dto.image, 'https://image.com/biceps.png');

        final serialized = dto.toJson();
        expect(serialized['_id'], 'm100');
        expect(serialized['name'], 'Biceps');
        expect(serialized['image'], 'https://image.com/biceps.png');
      });

      test(
        'toEntity maps correctly with trimmed strings and fallback for nulls',
        () {
          const dto = MuscleDto(
            id: 'm101',
            name: '  Triceps  ',
            image: 'https://img.png',
          );

          final entity = dto.toEntity();

          expect(entity.id, 'm101');
          expect(entity.name, 'Triceps');
          expect(entity.imageUrl, 'https://img.png');

          const nullDto = MuscleDto();
          final nullEntity = nullDto.toEntity();
          expect(nullEntity.id, '');
          expect(nullEntity.name, '');
          expect(nullEntity.imageUrl, '');
        },
      );
    });

    group('MuscleGroupDto', () {
      test('fromJson and toJson work correctly', () {
        final json = {'_id': 'g100', 'name': 'Chest'};

        final dto = MuscleGroupDto.fromJson(json);

        expect(dto.id, 'g100');
        expect(dto.name, 'Chest');

        final serialized = dto.toJson();
        expect(serialized['_id'], 'g100');
        expect(serialized['name'], 'Chest');
      });

      test('toEntity maps correctly and handles nulls', () {
        const dto = MuscleGroupDto(id: 'g1', name: '  Back  ');
        final entity = dto.toEntity();

        expect(entity.id, 'g1');
        expect(entity.name, 'Back');

        const nullDto = MuscleGroupDto();
        final nullEntity = nullDto.toEntity();
        expect(nullEntity.id, '');
        expect(nullEntity.name, '');
      });
    });

    group('MealCategoryDto', () {
      test('fromJson and toJson work correctly', () {
        final json = {
          'idCategory': 'c1',
          'strCategory': 'Chicken',
          'strCategoryThumb': 'https://chicken.png',
          'strCategoryDescription': 'Chicken meals',
        };

        final dto = MealCategoryDto.fromJson(json);

        expect(dto.idCategory, 'c1');
        expect(dto.strCategory, 'Chicken');
        expect(dto.strCategoryThumb, 'https://chicken.png');
        expect(dto.strCategoryDescription, 'Chicken meals');

        final serialized = dto.toJson();
        expect(serialized['idCategory'], 'c1');
        expect(serialized['strCategory'], 'Chicken');
      });

      test('toEntity maps correctly and handles nulls', () {
        const dto = MealCategoryDto(
          idCategory: 'c1',
          strCategory: 'Beef',
          strCategoryThumb: 'https://beef.png',
          strCategoryDescription: 'Beef dishes',
        );
        final entity = dto.toEntity();

        expect(entity.id, 'c1');
        expect(entity.name, 'Beef');
        expect(entity.thumbnailUrl, 'https://beef.png');
        expect(entity.description, 'Beef dishes');

        const nullDto = MealCategoryDto();
        final nullEntity = nullDto.toEntity();
        expect(nullEntity.id, '');
        expect(nullEntity.name, '');
        expect(nullEntity.thumbnailUrl, '');
        expect(nullEntity.description, '');
      });
    });

    group('Response DTOs', () {
      test('RandomMusclesResponseDto fromJson and toJson', () {
        final json = {
          'message': 'success',
          'totalMuscles': 1,
          'muscles': [
            {'_id': 'm1', 'name': 'Muscle 1', 'image': 'https://m1.png'},
          ],
        };

        final response = RandomMusclesResponseDto.fromJson(json);
        expect(response.message, 'success');
        expect(response.totalMuscles, 1);
        expect(response.muscles?.length, 1);

        final serialized = response.toJson();
        expect(serialized['message'], 'success');
      });

      test('MuscleGroupsResponseDto fromJson and toJson', () {
        final json = {
          'message': 'success',
          'musclesGroup': [
            {'_id': 'g1', 'name': 'Arms'},
          ],
        };

        final response = MuscleGroupsResponseDto.fromJson(json);
        expect(response.message, 'success');
        expect(response.musclesGroup?.length, 1);

        final serialized = response.toJson();
        expect(serialized['message'], 'success');
      });

      test('MusclesByGroupResponseDto fromJson and toJson', () {
        final json = {
          'message': 'success',
          'muscles': [
            {'_id': 'm1', 'name': 'Biceps', 'image': 'https://b.png'},
          ],
        };

        final response = MusclesByGroupResponseDto.fromJson(json);
        expect(response.message, 'success');
        expect(response.muscles?.length, 1);

        final serialized = response.toJson();
        expect(serialized['message'], 'success');
      });

      test('MealCategoriesResponseDto fromJson and toJson', () {
        final json = {
          'categories': [
            {
              'idCategory': '1',
              'strCategory': 'Dessert',
              'strCategoryThumb': 'https://dessert.png',
              'strCategoryDescription': 'Sweets',
            },
          ],
        };

        final response = MealCategoriesResponseDto.fromJson(json);
        expect(response.categories?.length, 1);
        expect(response.categories?.first.strCategory, 'Dessert');

        final serialized = response.toJson();
        expect(serialized['categories'], isNotNull);
      });
    });

    group('Domain Entities Equatable Props', () {
      test('MuscleEntity equality and props', () {
        const entity1 = MuscleEntity(
          id: '1',
          name: 'Chest',
          imageUrl: 'https://img.png',
        );
        const entity2 = MuscleEntity(
          id: '1',
          name: 'Chest',
          imageUrl: 'https://img.png',
        );
        const entity3 = MuscleEntity(
          id: '2',
          name: 'Back',
          imageUrl: 'https://img2.png',
        );

        expect(entity1, equals(entity2));
        expect(entity1 == entity3, isFalse);
        expect(entity1.props, ['1', 'Chest', 'https://img.png']);
      });

      test('MuscleGroupEntity equality and props', () {
        const group1 = MuscleGroupEntity(id: '1', name: 'Upper');
        const group2 = MuscleGroupEntity(id: '1', name: 'Upper');
        const group3 = MuscleGroupEntity(id: '2', name: 'Lower');

        expect(group1, equals(group2));
        expect(group1 == group3, isFalse);
        expect(group1.props, ['1', 'Upper']);
      });

      test('MealCategoryEntity equality and props', () {
        const meal1 = MealCategoryEntity(
          id: '1',
          name: 'Pasta',
          thumbnailUrl: 'https://pasta.png',
          description: 'Italian pasta',
        );
        const meal2 = MealCategoryEntity(
          id: '1',
          name: 'Pasta',
          thumbnailUrl: 'https://pasta.png',
          description: 'Italian pasta',
        );
        const meal3 = MealCategoryEntity(
          id: '2',
          name: 'Salad',
          thumbnailUrl: 'https://salad.png',
          description: 'Fresh salad',
        );

        expect(meal1, equals(meal2));
        expect(meal1 == meal3, isFalse);
        expect(meal1.props, [
          '1',
          'Pasta',
          'https://pasta.png',
          'Italian pasta',
        ]);
      });

      test('DifficultyLevelEntity equality and props', () {
        const lvl1 = DifficultyLevelEntity(id: '1', name: 'Beginner');
        const lvl2 = DifficultyLevelEntity(id: '1', name: 'Beginner');
        expect(lvl1, equals(lvl2));
        expect(lvl1.props, ['1', 'Beginner']);
      });

      test('PopularTrainingEntity equality, props, and levelColor', () {
        const ent1 = PopularTrainingEntity(
          id: 'ex1',
          title: 'Push-Up',
          totalTasks: 20,
          levelText: 'Beginner',
          imageUrl: 'https://img.png',
          videoUrl: 'https://yt.com/1',
        );
        const ent2 = PopularTrainingEntity(
          id: 'ex1',
          title: 'Push-Up',
          totalTasks: 20,
          levelText: 'Beginner',
          imageUrl: 'https://img.png',
          videoUrl: 'https://yt.com/1',
        );
        expect(ent1, equals(ent2));
        expect(ent1.levelColor, AppColors.primaryColor);

        const entIntermediate = PopularTrainingEntity(
          id: 'ex2',
          title: 'Dip',
          totalTasks: 10,
          levelText: 'Intermediate',
          imageUrl: 'https://img.png',
        );
        expect(entIntermediate.levelColor, const Color(0xFFFF9500));

        const entAdvanced = PopularTrainingEntity(
          id: 'ex3',
          title: 'Handstand Pushup',
          totalTasks: 5,
          levelText: 'Advanced',
          imageUrl: 'https://img.png',
        );
        expect(entAdvanced.levelColor, const Color(0xFFFF3B30));

        final copied = ent1.copyWith(levelText: 'Advanced');
        expect(copied.levelText, 'Advanced');
        expect(copied.id, ent1.id);
        expect(copied.title, ent1.title);
      });
    });

    group('DifficultyLevelDto and Response', () {
      test('fromJson, toJson, and toEntity', () {
        final json = {'_id': 'lvl1', 'name': ' Expert '};
        final dto = DifficultyLevelDto.fromJson(json);
        expect(dto.id, 'lvl1');
        expect(dto.name, ' Expert ');
        expect(dto.toJson()['_id'], 'lvl1');

        final entity = dto.toEntity();
        expect(entity.id, 'lvl1');
        expect(entity.name, 'Expert');

        const nullDto = DifficultyLevelDto();
        expect(nullDto.toEntity().id, '');
        expect(nullDto.toEntity().name, '');
      });

      test('DifficultyLevelsResponseDto fromJson and toJson', () {
        final json = {
          'message': 'success',
          'levels': [
            {'_id': '1', 'name': 'Novice'},
          ],
        };
        final dto = DifficultyLevelsResponseDto.fromJson(json);
        expect(dto.message, 'success');
        expect(dto.levels?.length, 1);
        expect(dto.toJson()['levels'], isNotNull);
      });
    });

    group('PopularExerciseDto and Response', () {
      test('fromJson and toJson', () {
        final json = {
          '_id': 'e1',
          'exercise': 'Plank',
          'difficulty_level': 'Beginner',
          'target_muscle_group': 'Core',
          'prime_mover_muscle': 'Abs',
          'image': 'https://plank.png',
          'short_youtube_demonstration_link': 'https://youtu.be/abc',
        };
        final dto = PopularExerciseDto.fromJson(json);
        expect(dto.id, 'e1');
        expect(dto.exercise, 'Plank');
        expect(dto.difficultyLevel, 'Beginner');
        expect(dto.image, 'https://plank.png');
        expect(dto.shortYoutubeDemonstrationLink, 'https://youtu.be/abc');

        final serialized = dto.toJson();
        expect(serialized['_id'], 'e1');
        expect(serialized['exercise'], 'Plank');
        expect(serialized['image'], 'https://plank.png');
      });

      test('ExercisesByMuscleDifficultyResponseDto fromJson and toJson', () {
        final json = {
          'message': 'success',
          'totalExercises': 10,
          'totalPages': 1,
          'currentPage': 1,
          'exercises': [
            {'_id': 'e1', 'exercise': 'Bench Press'},
          ],
        };
        final dto = ExercisesByMuscleDifficultyResponseDto.fromJson(json);
        expect(dto.totalExercises, 10);
        expect(dto.exercises?.length, 1);
        expect(dto.toJson()['totalExercises'], 10);
      });
    });
  });
}
