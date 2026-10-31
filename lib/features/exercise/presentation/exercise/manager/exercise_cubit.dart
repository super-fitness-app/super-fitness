import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/base/base_cubit.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/exercise_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/domain/use_cases/get_all_dfficulty_levels_use_case.dart';
import 'package:super_fitness/features/exercise/domain/use_cases/get_all_muscles_use_case.dart';
import 'package:super_fitness/features/exercise/domain/use_cases/get_exercises_by_muscle_and_dfficulty_use_case.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/manager/exercise_state.dart';

@injectable
class ExerciseCubit extends BaseCubit<ExerciseState, BaseEvent> {
  final GetExercisesByMuscleAndDfficultyUseCase
  _getExercisesByMuscleAndDfficultyUseCase;
  final GetAllMusclesUseCase _getAllMusclesUseCase;
  final GetAllDfficultyLevelsUseCase _allDfficultyLevelsUseCase;

  ExerciseCubit(
    this._getAllMusclesUseCase,
    this._getExercisesByMuscleAndDfficultyUseCase,
    this._allDfficultyLevelsUseCase,
  ) : super(const ExerciseState.initial());

  Future<void> getExercisesByMuscleAndDifficulty({
    required String language,
    required String difficultyLevelId,
    required String primeMoverMuscleId,
  }) async {
    emit(ExerciseState.loading(data: state.data));

    final result = await _getExercisesByMuscleAndDfficultyUseCase(
      language: language,
      difficultyLevelId: difficultyLevelId,
      primeMoverMuscleId: primeMoverMuscleId,
    );

    switch (result) {
      case Success<List<ExerciseEntity>>():
        final currentData = state.data ?? const ExerciseData();
        emit(
          ExerciseState.success(currentData.copyWith(exercises: result.data)),
        );

      case FailureResponse<List<ExerciseEntity>>():
        emit(ExerciseState.failure(result.failure, data: state.data));
    }
  }

  Future<void> getAllDifficultyLevels({required String language}) async {
    emit(ExerciseState.loading(data: state.data));

    final result = await _allDfficultyLevelsUseCase(language: language);

    switch (result) {
      case Success<List<DifficultyLevelEntity>>():
        final currentData = state.data ?? const ExerciseData();
        emit(ExerciseState.success(currentData.copyWith(levels: result.data)));

      case FailureResponse<List<DifficultyLevelEntity>>():
        emit(ExerciseState.failure(result.failure, data: state.data));
    }
  }

  Future<void> getAllMusclesByGroupID({required String musclesGroupId}) async {
    emit(ExerciseState.loading(data: state.data));
    final result = await _getAllMusclesUseCase(muscleGroupId: musclesGroupId);
    switch (result) {
      case Success<List<MuscleEntity>>():
        final currentData = state.data ?? const ExerciseData();
        emit(ExerciseState.success(currentData.copyWith(muscles: result.data)));

      case FailureResponse<List<MuscleEntity>>():
        emit(ExerciseState.failure(result.failure, data: state.data));
    }
  }

  @override
  void doEvent(Object event) {}
}
