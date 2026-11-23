import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';
import 'package:super_fitness/features/exercise/domain/use_cases/get_all_dfficulty_levels_use_case.dart';

import 'get_all_dfficulty_levels_use_case_test.mocks.dart';

@GenerateMocks([ExerciseRepo])
void main() {
  late MockExerciseRepo mockExerciseRepo;
  late GetAllDfficultyLevelsUseCase getAllDfficultyLevelsUseCase;

  setUp(() {
    mockExerciseRepo = MockExerciseRepo();
    getAllDfficultyLevelsUseCase = GetAllDfficultyLevelsUseCase(
      mockExerciseRepo,
    );
  });
  provideDummy<ApiResults<List<DifficultyLevelEntity>>>(
    Success<List<DifficultyLevelEntity>>([]),
  );

  group("GetAllDfficultyLevelsUseCase", () {
    test(
      " 'should return difficulty levels from repository when called'",
      () async {
        const language = 'en';
        const difficultyLevels = [
          DifficultyLevelEntity(id: 'level_1', name: 'Beginner'),
          DifficultyLevelEntity(id: 'level_2', name: 'Intermediate'),
        ];
        final expectedResult = Success<List<DifficultyLevelEntity>>(
          difficultyLevels,
        );
        when(
          mockExerciseRepo.getAllDifficultyLevels(language: language),
        ).thenAnswer((_) async => expectedResult);

        // act
        final result = await getAllDfficultyLevelsUseCase.call(
          language: language,
        );
        // Assert
        expect(result, isA<Success<List<DifficultyLevelEntity>>>());

        expect(result, same(expectedResult));

        verify(
          mockExerciseRepo.getAllDifficultyLevels(language: language),
        ).called(1);
      },
    );
  });
}
