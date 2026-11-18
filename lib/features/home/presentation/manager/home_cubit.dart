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

    final randomMusclesTask = () async {
      try {
        final result = await (_getRandomMusclesUseCase?.call() ??
            Future.value(const Success([])));
        List<MuscleEntity> randomMuscles = [];
        if (result is Success<List<MuscleEntity>>) {
          randomMuscles = result.data
              .where((muscle) => muscle.imageUrl.trim().isNotEmpty)
              .take(6)
              .toList();
        }
        final latest = state.data ?? const HomeData();
        emit(
          BaseState.success(
            latest.copyWith(
              randomMuscles: randomMuscles,
              isRandomMusclesLoading: false,
            ),
          ),
        );
      } catch (_) {
        final latest = state.data ?? const HomeData();
        emit(
          BaseState.success(latest.copyWith(isRandomMusclesLoading: false)),
        );
      }
    }();

    final muscleGroupsTask = () async {
      try {
        final result = await (_getMuscleGroupsUseCase?.call() ??
            Future.value(const Success([])));
        List<MuscleGroupEntity> muscleGroups = [];
        String? initialGroupId;
        if (result is Success<List<MuscleGroupEntity>>) {
          muscleGroups = result.data;
          if (muscleGroups.isNotEmpty) {
            initialGroupId = muscleGroups.first.id;
          }
        }
        final latest = state.data ?? const HomeData();
        emit(
          BaseState.success(
            latest.copyWith(
              muscleGroups: muscleGroups,
              selectedMuscleGroupId: initialGroupId,
            ),
          ),
        );

        if (initialGroupId != null && initialGroupId.isNotEmpty) {
          await _fetchMusclesForGroup(initialGroupId);
        } else {
          final latestAfter = state.data ?? const HomeData();
          emit(
            BaseState.success(
              latestAfter.copyWith(isMusclesByGroupLoading: false),
            ),
          );
        }
      } catch (_) {
        final latest = state.data ?? const HomeData();
        emit(
          BaseState.success(latest.copyWith(isMusclesByGroupLoading: false)),
        );
      }
    }();

    final mealCategoriesTask = () async {
      try {
        final result = await (_getMealCategoriesUseCase?.call() ??
            Future.value(const Success([])));
        List<MealCategoryEntity> mealCategories = [];
        if (result is Success<List<MealCategoryEntity>>) {
          mealCategories = result.data;
        }
        final latest = state.data ?? const HomeData();
        emit(
          BaseState.success(
            latest.copyWith(
              mealCategories: mealCategories,
              isMealCategoriesLoading: false,
            ),
          ),
        );
      } catch (_) {
        final latest = state.data ?? const HomeData();
        emit(
          BaseState.success(latest.copyWith(isMealCategoriesLoading: false)),
        );
      }
    }();

    await Future.wait([randomMusclesTask, muscleGroupsTask, mealCategoriesTask]);
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
      randomMuscles =
          result.data
              .where((muscle) => muscle.imageUrl.trim().isNotEmpty)
              .take(6)
              .toList();
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
