import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/data/data_source/remote/exercise_remote_data_source.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/difficulty_level_model.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/difficulty_levels_response_model.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/exercise_response_model.dart';
import 'package:super_fitness/features/exercise/data/repo_impl/exercise_repo_impl.dart';

import 'exercise_repo_impl_test.mocks.dart';

@GenerateMocks([ExerciseRemoteDataSource])
void main() {
  late MockExerciseRemoteDataSource mockRemoteDataSource;
  late ExerciseRepoImpl repository;

  setUp(() {
    mockRemoteDataSource = MockExerciseRemoteDataSource();
    repository = ExerciseRepoImpl(mockRemoteDataSource);
  });
  group("getAllDifficultyLevels", () {
    test(
      'should return Success with converted difficulty entities when remote call succeeds',
      () async {
        // Arrange
        const language = 'en';
        final difficultyLevelsResponseModel = DifficultyLevelsResponseModel(
          levels: [
            DifficultyLevelModel(id: "level_1", name: "Beginner"),
            DifficultyLevelModel(id: "level_2", name: "Intermediate"),
          ],
          message: "success",
        );
        when(
          mockRemoteDataSource.getAllDifficultyLevels(language: language),
        ).thenAnswer((_) async => difficultyLevelsResponseModel);

        // Act
        final result = await repository.getAllDifficultyLevels(
          language: language,
        );
        // Assert
        expect(result, isA<Success>());
        final success = result as Success;

        expect(success.data.length, 2);
        expect(success.data[0].id, 'level_1');
        expect(success.data[0].name, 'Beginner');
        expect(success.data[1].id, 'level_2');
        expect(success.data[1].name, 'Intermediate');
        // expect(result, same(difficultyLevelsResponseModel));
        verify(
          mockRemoteDataSource.getAllDifficultyLevels(language: language),
        ).called(1);
      },
    );
  });

  group('getExercisesByMuscleAndDifficulty', () {
    test(
      'should return Success with converted exercise entities when remote call succeeds',
      () async {
        const language = 'en';
        const difficultyLevelId = 'level_1';
        const primeMoverMuscleId = 'muscle_1';

        final exerciseResponseModel = ExerciseResponseModel(
          message: 'success',
          totalExercises: 0,
          totalPages: 0,
          currentPage: 1,
          exercises: [],
        );
        when(
          mockRemoteDataSource.getExercisesByMuscleAndDifficulty(
            language: language,
            difficultyLevelId: difficultyLevelId,
            primeMoverMuscleId: primeMoverMuscleId,
          ),
        ).thenAnswer((_) async => exerciseResponseModel);

        // Act
        final result = await repository.getExercisesByMuscleAndDifficulty(
          language: language,
          difficultyLevelId: difficultyLevelId,
          primeMoverMuscleId: primeMoverMuscleId,
        );
        // Assert
        expect(result, isA<Success>());
        final success = result as Success;

        expect(success.data.length, 0);
        // expect(result, same(exerciseResponseModel));
        verify(
          mockRemoteDataSource.getExercisesByMuscleAndDifficulty(
            language: language,
            difficultyLevelId: difficultyLevelId,
            primeMoverMuscleId: primeMoverMuscleId,
          ),
        ).called(1);
      },
    );
  });
}
