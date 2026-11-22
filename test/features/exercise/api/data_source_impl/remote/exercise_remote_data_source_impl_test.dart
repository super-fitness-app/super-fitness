import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/features/exercise/api/client/exercise_api_client.dart';
import 'package:super_fitness/features/exercise/api/data_source_impl/remote/exercise_remote_data_source_impl.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/difficulty_level_model.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/difficulty_levels_response_model.dart';
import 'package:super_fitness/features/exercise/data/model/exercise_models/exercise_response_model.dart';

import 'exercise_remote_data_source_impl_test.mocks.dart';

@GenerateMocks([ExerciseApiClient])
void main() {
  late MockExerciseApiClient mockExerciseApiClient;
  late ExerciseRemoteDataSourceImpl exerciseRemoteDataSourceImpl;

  setUp(() {
    mockExerciseApiClient = MockExerciseApiClient();
    exerciseRemoteDataSourceImpl = ExerciseRemoteDataSourceImpl(
      mockExerciseApiClient,
    );
  });

  group('getAllDifficultyLevels', () {
    test('should call API client with correct language', () async {
      // Arrange
      const language = 'en';
      const response = DifficultyLevelsResponseModel(
        levels: [
          DifficultyLevelModel(id: "level_1", name: "Beginner"),
          DifficultyLevelModel(id: "level_2", name: "Intermediate"),
        ],
        message: "success",
      );
      when(
        mockExerciseApiClient.getAllDifficultyLevels(language: language),
      ).thenAnswer((_) async => response);

      // Act
      final result = await exerciseRemoteDataSourceImpl.getAllDifficultyLevels(
        language: language,
      );
      // Assert
      expect(result, same(response));
      verify(
        mockExerciseApiClient.getAllDifficultyLevels(language: language),
      ).called(1);
    });
  });

  group('getExercisesByMuscleAndDifficulty', () {
    test('should call API client with correct parameters', () async {
      // Arrange
      const language = 'en';
      const difficultyLevelId = 'difficulty_123';
      const primeMoverMuscleId = 'muscle_456';
      const response = ExerciseResponseModel(
        message: 'success',
        totalExercises: 0,
        totalPages: 0,
        currentPage: 1,
        exercises: [],
      );
      when(
        mockExerciseApiClient.getExercisesByMuscleAndDifficulty(
          language,
          difficultyLevelId,
          primeMoverMuscleId,
        ),
      ).thenAnswer((_) async => response);
      // Act
      final result = await exerciseRemoteDataSourceImpl
          .getExercisesByMuscleAndDifficulty(
            language: language,
            difficultyLevelId: difficultyLevelId,
            primeMoverMuscleId: primeMoverMuscleId,
          );
      // Assert
      expect(result, same(response));
      verify(
        mockExerciseApiClient.getExercisesByMuscleAndDifficulty(
          language,
          difficultyLevelId,
          primeMoverMuscleId,
        ),
      ).called(1);
    });
  });
}
