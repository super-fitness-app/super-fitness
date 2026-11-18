import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/home/domain/entities/meal_category_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/home/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_meal_categories_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:super_fitness/features/home/domain/use_cases/get_random_muscles_use_case.dart';

part 'home_event.dart';
part 'home_state.dart';

@injectable
class HomeCubit extends BaseCubit<HomeState, BaseEvent> {
  final GetRandomMusclesUseCase? _getRandomMusclesUseCase;
  final GetMuscleGroupsUseCase? _getMuscleGroupsUseCase;
  final GetMusclesByGroupUseCase? _getMusclesByGroupUseCase;
  final GetMealCategoriesUseCase? _getMealCategoriesUseCase;

  HomeCubit([
    this._getRandomMusclesUseCase,
    this._getMuscleGroupsUseCase,
    this._getMusclesByGroupUseCase,
    this._getMealCategoriesUseCase,
  ]) : super(const BaseState<HomeData>.initial());

  @override
  void doEvent(Object event) {
    switch (event) {
      case GetHomeDataEvent():
        _onGetHomeData(event);
      case SelectMuscleGroupEvent():
        _onSelectMuscleGroup(event);
      case RefreshRandomMusclesEvent():
        _onRefreshRandomMuscles(event);
      default:
        break;
    }
  }

  Future<void> _onGetHomeData(GetHomeDataEvent event) async {
    final currentData = state.data ?? const HomeData();
    emit(
      BaseState.success(
        currentData.copyWith(
          isRandomMusclesLoading: true,
          isMusclesByGroupLoading: true,
          isMealCategoriesLoading: true,
        ),
      ),
    );

    final randomMusclesFuture =
        _getRandomMusclesUseCase?.call() ?? Future.value(const Success([]));
    final muscleGroupsFuture =
        _getMuscleGroupsUseCase?.call() ?? Future.value(const Success([]));
    final mealCategoriesFuture =
        _getMealCategoriesUseCase?.call() ?? Future.value(const Success([]));

    final results = await Future.wait([
      randomMusclesFuture,
      muscleGroupsFuture,
      mealCategoriesFuture,
    ]);

    final randomMusclesResult = results[0] as ApiResults<List<MuscleEntity>>;
    final muscleGroupsResult =
        results[1] as ApiResults<List<MuscleGroupEntity>>;
    final mealCategoriesResult =
        results[2] as ApiResults<List<MealCategoryEntity>>;

    List<MuscleEntity> randomMuscles = [];
    if (randomMusclesResult is Success<List<MuscleEntity>>) {
      randomMuscles = randomMusclesResult.data;
    }

    List<MuscleGroupEntity> muscleGroups = [];
    String? initialGroupId;
    if (muscleGroupsResult is Success<List<MuscleGroupEntity>>) {
      muscleGroups = muscleGroupsResult.data;
      if (muscleGroups.isNotEmpty) {
        initialGroupId = muscleGroups.first.id;
      }
    }

    List<MealCategoryEntity> mealCategories = [];
    if (mealCategoriesResult is Success<List<MealCategoryEntity>>) {
      mealCategories = mealCategoriesResult.data;
    }

    final updatedData = (state.data ?? const HomeData()).copyWith(
      randomMuscles: randomMuscles,
      isRandomMusclesLoading: false,
      muscleGroups: muscleGroups,
      selectedMuscleGroupId: initialGroupId,
      mealCategories: mealCategories,
      isMealCategoriesLoading: false,
    );
    emit(BaseState.success(updatedData));

    if (initialGroupId != null && initialGroupId.isNotEmpty) {
      await _fetchMusclesForGroup(initialGroupId);
    } else {
      emit(
        BaseState.success(
          (state.data ?? updatedData).copyWith(isMusclesByGroupLoading: false),
        ),
      );
    }
  }

  Future<void> _onSelectMuscleGroup(SelectMuscleGroupEvent event) async {
    if (state.data?.selectedMuscleGroupId == event.groupId) return;
    await _fetchMusclesForGroup(event.groupId);
  }

  Future<void> _fetchMusclesForGroup(String groupId) async {
    final currentData = state.data ?? const HomeData();
    emit(
      BaseState.success(
        currentData.copyWith(
          selectedMuscleGroupId: groupId,
          isMusclesByGroupLoading: true,
        ),
      ),
    );

    final result =
        await (_getMusclesByGroupUseCase?.call(groupId) ??
            Future.value(const Success([])));

    List<MuscleEntity> muscles = [];
    if (result is Success<List<MuscleEntity>>) {
      muscles = result.data;
    }

    emit(
      BaseState.success(
        (state.data ?? currentData).copyWith(
          selectedMuscleGroupId: groupId,
          musclesByGroup: muscles,
          isMusclesByGroupLoading: false,
        ),
      ),
    );
  }

  Future<void> _onRefreshRandomMuscles(RefreshRandomMusclesEvent event) async {
    final currentData = state.data ?? const HomeData();
    emit(BaseState.success(currentData.copyWith(isRandomMusclesLoading: true)));

    final result =
        await (_getRandomMusclesUseCase?.call() ??
            Future.value(const Success([])));

    List<MuscleEntity> randomMuscles = currentData.randomMuscles;
    if (result is Success<List<MuscleEntity>>) {
      randomMuscles = result.data;
    }

    emit(
      BaseState.success(
        (state.data ?? currentData).copyWith(
          randomMuscles: randomMuscles,
          isRandomMusclesLoading: false,
        ),
      ),
    );
  }
}
