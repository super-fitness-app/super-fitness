import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/home/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/home/domain/entities/popular_training_entity.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_meal_categories_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_popular_training_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_random_muscles_use_case.dart';
import 'package:super_fitness/features/home/presentation/manager/home_cubit.dart';

class FakeHomeRepo implements HomeRepo {
  List<MuscleEntity> randomMuscles = const [
    MuscleEntity(id: '1', name: 'Biceps', imageUrl: 'https://img.png'),
  ];
  List<MuscleGroupEntity> muscleGroups = const [
    MuscleGroupEntity(id: 'g1', name: 'Arms'),
  ];
  List<MuscleEntity> groupMuscles = const [
    MuscleEntity(id: 'm1', name: 'Triceps', imageUrl: 'https://img2.png'),
  ];
  List<MealCategoryEntity> mealCategories = const [
    MealCategoryEntity(
      id: 'c1',
      name: 'Beef',
      thumbnailUrl: 'https://beef.png',
      description: 'Beef desc',
    ),
  ];
  List<DifficultyLevelEntity> difficultyLevels = const [
    DifficultyLevelEntity(id: 'lvl1', name: 'Beginner'),
  ];
  List<PopularTrainingEntity> popularTrainings = const [
    PopularTrainingEntity(
      id: 'p1',
      title: 'Push Up',
      totalTasks: 12,
      levelText: 'Beginner',
      imageUrl: 'https://pushup.png',
    ),
  ];

  bool failRandomMuscles = false;
  bool failMuscleGroups = false;
  bool failGroupMuscles = false;
  bool failMealCategories = false;
  bool failDifficultyLevels = false;
  bool failExercises = false;
  bool throwException = false;

  @override
  Future<ApiResults<List<MuscleEntity>>> getRandomMuscles() async {
    if (throwException) {
      throw Exception('Unexpected error');
    }
    if (failRandomMuscles) {
      return const Failure(ServerMessageFailure('Random muscles error'));
    }
    return Success(randomMuscles);
  }

  @override
  Future<ApiResults<List<MuscleGroupEntity>>> getMuscleGroups() async {
    if (throwException) {
      throw Exception('Unexpected error');
    }
    if (failMuscleGroups) {
      return const Failure(ServerMessageFailure('Muscle groups error'));
    }
    return Success(muscleGroups);
  }

  @override
  Future<ApiResults<List<MuscleEntity>>> getMusclesByMuscleGroupId(
    String id,
  ) async {
    if (throwException) {
      throw Exception('Unexpected error');
    }
    if (failGroupMuscles) {
      return const Failure(ServerMessageFailure('Group muscles error'));
    }
    return Success(groupMuscles);
  }

  @override
  Future<ApiResults<List<MealCategoryEntity>>> getMealCategories() async {
    if (throwException) {
      throw Exception('Unexpected error');
    }
    if (failMealCategories) {
      return const Failure(ServerMessageFailure('Meal categories error'));
    }
    return Success(mealCategories);
  }

  @override
  Future<ApiResults<List<DifficultyLevelEntity>>> getDifficultyLevels() async {
    if (throwException) {
      throw Exception('Unexpected error');
    }
    if (failDifficultyLevels) {
      return const Failure(ServerMessageFailure('Levels error'));
    }
    return Success(difficultyLevels);
  }

  @override
  Future<ApiResults<List<PopularTrainingEntity>>>
  getExercisesByMuscleAndDifficulty({
    required String difficultyLevelId,
    required String primeMoverMuscleId,
    String? fallbackImageUrl,
    String? levelName,
  }) async {
    if (throwException) {
      throw Exception('Unexpected error');
    }
    if (failExercises) {
      return const Failure(ServerMessageFailure('Exercises error'));
    }
    return Success(popularTrainings);
  }
}

void main() {
  late FakeHomeRepo fakeRepo;
  late GetRandomMusclesUseCase getRandomMusclesUseCase;
  late GetMuscleGroupsUseCase getMuscleGroupsUseCase;
  late GetMusclesByGroupUseCase getMusclesByGroupUseCase;
  late GetMealCategoriesUseCase getMealCategoriesUseCase;
  late GetPopularTrainingUseCase getPopularTrainingUseCase;
  late HomeCubit homeCubit;

  setUp(() {
    fakeRepo = FakeHomeRepo();
    getRandomMusclesUseCase = GetRandomMusclesUseCase(fakeRepo);
    getMuscleGroupsUseCase = GetMuscleGroupsUseCase(fakeRepo);
    getMusclesByGroupUseCase = GetMusclesByGroupUseCase(fakeRepo);
    getMealCategoriesUseCase = GetMealCategoriesUseCase(fakeRepo);
    getPopularTrainingUseCase = GetPopularTrainingUseCase(fakeRepo);

    homeCubit = HomeCubit(
      getRandomMusclesUseCase,
      getMuscleGroupsUseCase,
      getMusclesByGroupUseCase,
      getMealCategoriesUseCase,
      getPopularTrainingUseCase,
    );
  });

  tearDown(() {
    homeCubit.close();
  });

  group('HomeCubit Tests', () {
    test('initial state is correct', () {
      expect(homeCubit.state, const BaseState<HomeData>.initial());
    });

    test(
      'GetHomeDataEvent loads random muscles, muscle groups, and meal categories',
      () async {
        homeCubit.doEvent(const GetHomeDataEvent());

        await expectLater(
          homeCubit.stream,
          emitsThrough(
            predicate<HomeState>((state) {
              final data = state.data;
              return data != null &&
                  data.randomMuscles.length == 1 &&
                  data.muscleGroups.length == 1 &&
                  data.musclesByGroup.length == 1 &&
                  data.mealCategories.length == 1 &&
                  !data.isRandomMusclesLoading &&
                  !data.isMusclesByGroupLoading &&
                  !data.isMealCategoriesLoading;
            }),
          ),
        );
      },
    );

    test(
      'GetHomeDataEvent filters out random muscles with empty imageUrl',
      () async {
        fakeRepo.randomMuscles = const [
          MuscleEntity(id: '1', name: 'Valid', imageUrl: 'https://img.png'),
          MuscleEntity(id: '2', name: 'Empty', imageUrl: ''),
          MuscleEntity(id: '3', name: 'Spaces', imageUrl: '   '),
        ];

        homeCubit.doEvent(const GetHomeDataEvent());

        await expectLater(
          homeCubit.stream,
          emitsThrough(
            predicate<HomeState>((state) {
              final data = state.data;
              return data != null &&
                  !data.isRandomMusclesLoading &&
                  data.randomMuscles.length == 1 &&
                  data.randomMuscles.first.name == 'Valid';
            }),
          ),
        );
      },
    );

    test(
      'GetHomeDataEvent limits random muscles to at most 6 elements',
      () async {
        fakeRepo.randomMuscles = List.generate(
          10,
          (i) => MuscleEntity(
            id: 'm$i',
            name: 'Muscle $i',
            imageUrl: 'https://img$i.png',
          ),
        );

        homeCubit.doEvent(const GetHomeDataEvent());

        await expectLater(
          homeCubit.stream,
          emitsThrough(
            predicate<HomeState>((state) {
              final data = state.data;
              return data != null &&
                  !data.isRandomMusclesLoading &&
                  data.randomMuscles.length == 6;
            }),
          ),
        );
      },
    );

    test('SelectMuscleGroupEvent fetches muscles for selected group', () async {
      homeCubit.doEvent(const SelectMuscleGroupEvent('g2'));

      await expectLater(
        homeCubit.stream,
        emitsThrough(
          predicate<HomeState>((state) {
            final data = state.data;
            return data != null &&
                data.selectedMuscleGroupId == 'g2' &&
                !data.isMusclesByGroupLoading;
          }),
        ),
      );
    });

    test('GetHomeDataEvent handles section failures gracefully', () async {
      fakeRepo.failRandomMuscles = true;
      fakeRepo.failMuscleGroups = true;
      fakeRepo.failMealCategories = true;

      homeCubit.doEvent(const GetHomeDataEvent());

      await expectLater(
        homeCubit.stream,
        emitsThrough(
          predicate<HomeState>((state) {
            final data = state.data;
            return data != null &&
                !data.isRandomMusclesLoading &&
                !data.isMusclesByGroupLoading &&
                !data.isMealCategoriesLoading;
          }),
        ),
      );
    });

    test(
      'GetHomeDataEvent handles exceptions thrown in tasks gracefully',
      () async {
        fakeRepo.throwException = true;

        homeCubit.doEvent(const GetHomeDataEvent());

        await expectLater(
          homeCubit.stream,
          emitsThrough(
            predicate<HomeState>((state) {
              final data = state.data;
              return data != null &&
                  !data.isRandomMusclesLoading &&
                  !data.isMusclesByGroupLoading &&
                  !data.isMealCategoriesLoading;
            }),
          ),
        );
      },
    );

    test('GetHomeDataEvent handles empty muscle groups gracefully', () async {
      fakeRepo.muscleGroups = [];

      homeCubit.doEvent(const GetHomeDataEvent());

      await expectLater(
        homeCubit.stream,
        emitsThrough(
          predicate<HomeState>((state) {
            final data = state.data;
            return data != null &&
                data.muscleGroups.isEmpty &&
                data.selectedMuscleGroupId == null &&
                !data.isMusclesByGroupLoading;
          }),
        ),
      );
    });

    test(
      'SelectMuscleGroupEvent ignores selection if already selected',
      () async {
        homeCubit.doEvent(const SelectMuscleGroupEvent('g1'));
        await pumpEventQueue();

        final statesCountBefore = homeCubit.state;
        homeCubit.doEvent(const SelectMuscleGroupEvent('g1'));
        await pumpEventQueue();

        expect(homeCubit.state, equals(statesCountBefore));
      },
    );

    test('SelectMuscleGroupEvent handles failure gracefully', () async {
      fakeRepo.failGroupMuscles = true;

      homeCubit.doEvent(const SelectMuscleGroupEvent('g3'));

      await expectLater(
        homeCubit.stream,
        emitsThrough(
          predicate<HomeState>((state) {
            final data = state.data;
            return data != null &&
                data.selectedMuscleGroupId == 'g3' &&
                data.musclesByGroup.isEmpty &&
                !data.isMusclesByGroupLoading;
          }),
        ),
      );
    });

    test(
      'RefreshRandomMusclesEvent refreshes and filters random muscles',
      () async {
        fakeRepo.randomMuscles = const [
          MuscleEntity(id: 'm1', name: 'Valid', imageUrl: 'https://valid.png'),
          MuscleEntity(id: 'm2', name: 'NoImage', imageUrl: ''),
        ];

        homeCubit.doEvent(const RefreshRandomMusclesEvent());

        await expectLater(
          homeCubit.stream,
          emitsThrough(
            predicate<HomeState>((state) {
              final data = state.data;
              return data != null &&
                  !data.isRandomMusclesLoading &&
                  data.randomMuscles.length == 1 &&
                  data.randomMuscles.first.name == 'Valid';
            }),
          ),
        );
      },
    );

    test('RefreshRandomMusclesEvent handles failure gracefully', () async {
      fakeRepo.failRandomMuscles = true;

      homeCubit.doEvent(const RefreshRandomMusclesEvent());

      await expectLater(
        homeCubit.stream,
        emitsThrough(
          predicate<HomeState>((state) {
            final data = state.data;
            return data != null && !data.isRandomMusclesLoading;
          }),
        ),
      );
    });

    test('HomeData copyWith and props behave correctly', () {
      const data1 = HomeData();
      final data2 = data1.copyWith(
        randomMuscles: const [
          MuscleEntity(id: '1', name: 'M1', imageUrl: 'img'),
        ],
        isRandomMusclesLoading: true,
        selectedMuscleGroupId: 'g1',
        isMusclesByGroupLoading: true,
        isMealCategoriesLoading: true,
      );

      expect(data2.randomMuscles.length, 1);
      expect(data2.isRandomMusclesLoading, isTrue);
      expect(data2.selectedMuscleGroupId, 'g1');
      expect(data2.isMusclesByGroupLoading, isTrue);
      expect(data2.isMealCategoriesLoading, isTrue);

      final data3 = data2.copyWith();
      expect(data3, equals(data2));
      expect(data1 == data2, isFalse);
    });

    test('RefreshHomeDataEvent reloads all home sections', () async {
      homeCubit.doEvent(const RefreshHomeDataEvent());

      await expectLater(
        homeCubit.stream,
        emitsThrough(
          predicate<HomeState>((state) {
            final data = state.data;
            return data != null &&
                data.randomMuscles.isNotEmpty &&
                !data.isRandomMusclesLoading &&
                !data.isPopularTrainingsLoading;
          }),
        ),
      );
    });

    test('refreshData() reloads all home sections and completes', () async {
      await homeCubit.refreshData();

      final data = homeCubit.state.data;
      expect(data, isNotNull);
      expect(data!.randomMuscles.isNotEmpty, isTrue);
      expect(data.popularTrainings.isNotEmpty, isTrue);
      expect(data.isRandomMusclesLoading, isFalse);
      expect(data.isPopularTrainingsLoading, isFalse);
    });

    test('HomeEvent classes instantiate correctly', () {
      expect(const GetHomeDataEvent(), isA<HomeEvent>());
      expect(const SelectMuscleGroupEvent('1'), isA<HomeEvent>());
      expect(const RefreshRandomMusclesEvent(), isA<HomeEvent>());
      expect(const RefreshPopularTrainingEvent(), isA<HomeEvent>());
      expect(const RefreshHomeDataEvent(), isA<HomeEvent>());
    });
  });
}
