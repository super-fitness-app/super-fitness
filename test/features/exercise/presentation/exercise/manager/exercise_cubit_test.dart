import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/config/base/base_state.dart';

import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/exercise/domain/use_cases/get_all_dfficulty_levels_use_case.dart';
import 'package:super_fitness/features/exercise/domain/use_cases/get_exercises_by_muscle_and_dfficulty_use_case.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/manager/exercise_cubit.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/manager/exercise_event.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/manager/exercise_state.dart';

import 'exercise_cubit_test.mocks.dart';

@GenerateMocks([
  GetAllDfficultyLevelsUseCase,
  GetExercisesByMuscleAndDfficultyUseCase,
])
void main() {
  provideDummy<ApiResults<List<DifficultyLevelEntity>>>(
    Success<List<DifficultyLevelEntity>>([]),
  );

  // Register the exercise dummy here too once we confirm its entity type.
  late MockGetAllDfficultyLevelsUseCase mockGetAllDifficultyLevels;
  late MockGetExercisesByMuscleAndDfficultyUseCase mockGetExercises;
  late ExerciseCubit cubit;

  setUp(() {
    mockGetAllDifficultyLevels = MockGetAllDfficultyLevelsUseCase();
    mockGetExercises = MockGetExercisesByMuscleAndDfficultyUseCase();

    cubit = ExerciseCubit(mockGetExercises, mockGetAllDifficultyLevels);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('GetAllDifficultyLevels', () {
    const language = 'en';

    const levels = [
      DifficultyLevelEntity(id: 'level_1', name: 'Beginner'),
      DifficultyLevelEntity(id: 'level_2', name: 'Intermediate'),
    ];

    blocTest<ExerciseCubit, ExerciseState>(
      'emits loading and success when difficulty levels are retrieved',
      build: () {
        when(
          mockGetAllDifficultyLevels.call(language: language),
        ).thenAnswer((_) async => Success<List<DifficultyLevelEntity>>(levels));

        return cubit;
      },
      act: (cubit) async {
        cubit.doEvent(GetAllDifficultyLevelsEvent(language: language));
      },
      expect: () => [
        BaseState<ExerciseData>.loading(),
        BaseState<ExerciseData>.success(ExerciseData(levels: levels)),
      ],
      verify: (_) {
        verify(mockGetAllDifficultyLevels.call(language: language)).called(1);
      },
    );
  });
}
