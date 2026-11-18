import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/home/data/data_source/remote/home_remote_data_source.dart';
import 'package:super_fitness/features/home/data/models/meal_categories_response_dto.dart';
import 'package:super_fitness/features/home/data/models/meal_category_dto.dart';
import 'package:super_fitness/features/home/data/models/muscle_dto.dart';
import 'package:super_fitness/features/home/data/models/muscle_group_dto.dart';
import 'package:super_fitness/features/home/data/models/muscle_groups_response_dto.dart';
import 'package:super_fitness/features/home/data/models/muscles_by_group_response_dto.dart';
import 'package:super_fitness/features/home/data/models/random_muscles_response_dto.dart';
import 'package:super_fitness/features/home/data/repo_impl/home_repo_impl.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';

class FakeHomeRemoteDataSource implements HomeRemoteDataSource {
  @override
  Future<RandomMusclesResponseDto> getRandomMuscles() async {
    return const RandomMusclesResponseDto(
      message: 'success',
      totalMuscles: 1,
      muscles: [
        MuscleDto(id: 'm1', name: 'Deltoid', image: 'https://deltoid.png'),
      ],
    );
  }

  @override
  Future<MuscleGroupsResponseDto> getMuscleGroups() async {
    return const MuscleGroupsResponseDto(
      message: 'success',
      musclesGroup: [MuscleGroupDto(id: 'g1', name: 'Shoulders')],
    );
  }

  @override
  Future<MusclesByGroupResponseDto> getMusclesByMuscleGroupId(String id) async {
    return const MusclesByGroupResponseDto(
      message: 'success',
      muscles: [
        MuscleDto(id: 'm2', name: 'Anterior Deltoid', image: 'https://ant.png'),
      ],
    );
  }

  @override
  Future<MealCategoriesResponseDto> getMealCategories() async {
    return const MealCategoriesResponseDto(
      categories: [
        MealCategoryDto(
          idCategory: 'c1',
          strCategory: 'Chicken',
          strCategoryThumb: 'https://chicken.png',
          strCategoryDescription: 'Chicken desc',
        ),
      ],
    );
  }
}

void main() {
  late FakeHomeRemoteDataSource fakeDataSource;
  late HomeRepoImpl repo;

  setUp(() {
    fakeDataSource = FakeHomeRemoteDataSource();
    repo = HomeRepoImpl(fakeDataSource);
  });

  group('HomeRepoImpl Tests', () {
    test(
      'getRandomMuscles returns mapped list of MuscleEntity on success',
      () async {
        final result = await repo.getRandomMuscles();

        expect(result, isA<Success<List<MuscleEntity>>>());
        final data = (result as Success<List<MuscleEntity>>).data;
        expect(data.length, 1);
        expect(data.first.name, 'Deltoid');
      },
    );

    test(
      'getMuscleGroups returns mapped list of MuscleGroupEntity on success',
      () async {
        final result = await repo.getMuscleGroups();

        expect(result, isA<Success<List<MuscleGroupEntity>>>());
        final data = (result as Success<List<MuscleGroupEntity>>).data;
        expect(data.length, 1);
        expect(data.first.name, 'Shoulders');
      },
    );

    test(
      'getMusclesByMuscleGroupId returns mapped list of MuscleEntity on success',
      () async {
        final result = await repo.getMusclesByMuscleGroupId('g1');

        expect(result, isA<Success<List<MuscleEntity>>>());
        final data = (result as Success<List<MuscleEntity>>).data;
        expect(data.length, 1);
        expect(data.first.name, 'Anterior Deltoid');
      },
    );

    test(
      'getMealCategories returns mapped list of MealCategoryEntity on success',
      () async {
        final result = await repo.getMealCategories();

        expect(result, isA<Success<List<MealCategoryEntity>>>());
        final data = (result as Success<List<MealCategoryEntity>>).data;
        expect(data.length, 1);
        expect(data.first.name, 'Chicken');
      },
    );
  });
}
