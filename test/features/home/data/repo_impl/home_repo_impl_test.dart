import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
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

class FakeStorageService implements StorageService {
  final Map<String, String> _storage = {};

  @override
  Future<void> delete(String key) async {
    _storage.remove(key);
  }

  @override
  Future<String> get(String key) async {
    return _storage[key] ?? '';
  }

  @override
  Future<void> save(String key, String value) async {
    _storage[key] = value;
  }
}

class FakeHomeRemoteDataSource implements HomeRemoteDataSource {
  RandomMusclesResponseDto randomMusclesResponse = const RandomMusclesResponseDto(
    message: 'success',
    totalMuscles: 1,
    muscles: [
      MuscleDto(id: 'm1', name: 'Deltoid', image: 'https://deltoid.png'),
    ],
  );

  @override
  Future<RandomMusclesResponseDto> getRandomMuscles() async {
    return randomMusclesResponse;
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
      'getRandomMuscles filters out items where image is null or empty',
      () async {
        fakeDataSource.randomMusclesResponse = const RandomMusclesResponseDto(
          message: 'success',
          totalMuscles: 3,
          muscles: [
            MuscleDto(id: 'm1', name: 'WithImage', image: 'https://img.png'),
            MuscleDto(id: 'm2', name: 'NullImage', image: null),
            MuscleDto(id: 'm3', name: 'EmptyImage', image: '   '),
          ],
        );

        final result = await repo.getRandomMuscles();

        expect(result, isA<Success<List<MuscleEntity>>>());
        final data = (result as Success<List<MuscleEntity>>).data;
        expect(data.length, 1);
        expect(data.first.name, 'WithImage');
      },
    );

    test(
      'getRandomMuscles returns at most 6 elements when data source has more than 6',
      () async {
        fakeDataSource.randomMusclesResponse = RandomMusclesResponseDto(
          message: 'success',
          totalMuscles: 10,
          muscles: List.generate(
            10,
            (i) => MuscleDto(
              id: 'm$i',
              name: 'Muscle $i',
              image: 'https://img$i.png',
            ),
          ),
        );

        final result = await repo.getRandomMuscles();

        expect(result, isA<Success<List<MuscleEntity>>>());
        final data = (result as Success<List<MuscleEntity>>).data;
        expect(data.length, 6);
      },
    );

    test(
      'getRandomMuscles rotates elements by prioritizing unseen ones on next app start',
      () async {
        final fakeStorage = FakeStorageService();
        final repoWithStorage = HomeRepoImpl(fakeDataSource, fakeStorage);

        fakeDataSource.randomMusclesResponse = RandomMusclesResponseDto(
          message: 'success',
          totalMuscles: 12,
          muscles: List.generate(
            12,
            (i) => MuscleDto(
              id: 'm$i',
              name: 'Muscle $i',
              image: 'https://img$i.png',
            ),
          ),
        );

        // First app launch
        final firstResult = await repoWithStorage.getRandomMuscles();
        final firstList = (firstResult as Success<List<MuscleEntity>>).data;
        expect(firstList.length, 6);
        final firstIds = firstList.map((m) => m.id).toSet();

        // Second app launch (simulating app restart with persisted storage)
        final secondResult = await repoWithStorage.getRandomMuscles();
        final secondList = (secondResult as Success<List<MuscleEntity>>).data;
        expect(secondList.length, 6);
        final secondIds = secondList.map((m) => m.id).toSet();

        // Since 12 muscles exist and 6 were shown, the next 6 are completely disjoint!
        expect(firstIds.intersection(secondIds), isEmpty);
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
