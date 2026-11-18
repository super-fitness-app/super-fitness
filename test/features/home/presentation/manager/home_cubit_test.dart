import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/home/domain/repo/home_repo.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_meal_categories_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_muscles_by_group_use_case.dart';
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

  @override
  Future<ApiResults<List<MuscleEntity>>> getRandomMuscles() async {
    return Success(randomMuscles);
  }

  @override
  Future<ApiResults<List<MuscleGroupEntity>>> getMuscleGroups() async {
    return Success(muscleGroups);
  }

  @override
  Future<ApiResults<List<MuscleEntity>>> getMusclesByMuscleGroupId(
    String id,
  ) async {
    return Success(groupMuscles);
  }

  @override
  Future<ApiResults<List<MealCategoryEntity>>> getMealCategories() async {
    return Success(mealCategories);
  }
}

void main() {
  late FakeHomeRepo fakeRepo;
  late GetRandomMusclesUseCase getRandomMusclesUseCase;
  late GetMuscleGroupsUseCase getMuscleGroupsUseCase;
  late GetMusclesByGroupUseCase getMusclesByGroupUseCase;
  late GetMealCategoriesUseCase getMealCategoriesUseCase;
  late HomeCubit homeCubit;

  setUp(() {
    fakeRepo = FakeHomeRepo();
    getRandomMusclesUseCase = GetRandomMusclesUseCase(fakeRepo);
    getMuscleGroupsUseCase = GetMuscleGroupsUseCase(fakeRepo);
    getMusclesByGroupUseCase = GetMusclesByGroupUseCase(fakeRepo);
    getMealCategoriesUseCase = GetMealCategoriesUseCase(fakeRepo);

    homeCubit = HomeCubit(
      getRandomMusclesUseCase,
      getMuscleGroupsUseCase,
      getMusclesByGroupUseCase,
      getMealCategoriesUseCase,
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
  });
}
