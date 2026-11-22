import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/domain/entities/exercise_entity.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';
import 'package:super_fitness/features/exercise/domain/use_cases/get_exercises_by_muscle_and_dfficulty_use_case.dart';

import 'get_all_dfficulty_levels_use_case_test.mocks.dart';

@GenerateMocks([ExerciseRepo])
void main() {
  late MockExerciseRepo mockExerciseRepo;
  late GetExercisesByMuscleAndDfficultyUseCase
  getExercisesByMuscleAndDifficulty;

  setUp(() {
    mockExerciseRepo = MockExerciseRepo();
    getExercisesByMuscleAndDifficulty = GetExercisesByMuscleAndDfficultyUseCase(
      mockExerciseRepo,
    );
  });

  provideDummy<ApiResults<List<ExerciseEntity>>>(
    Success<List<ExerciseEntity>>([]),
  );
  group("getExercisesByMuscleAndDfficultyUseCase", () {
    test(
      " 'should return getExercisesByMuscleAndDfficultyUseCase from repository when called'",
      () async {
        const language = 'en';
        const difficultyLevelId = 'level_1';
        const primeMoverMuscleId = 'muscle_1';

        const allExercises = [
          ExerciseEntity(
            id: 'level_2',
            exercise: 'Intermediate',
            difficultyLevel: '',
            targetMuscleGroup: '',
            primeMoverMuscle: '',
            primaryEquipment: '',
            primaryItems: 0,
            secondaryItems: 0,
            posture: '',
            singleOrDoubleArm: '',
            continuousOrAlternatingArms: '',
            grip: '',
            loadPositionEnding: '',
            continuousOrAlternatingLegs: '',
            footElevation: '',
            combinationExercises: '',
            movementPattern1: '',
            planeOfMotion1: '',
            bodyRegion: '',
            forceType: '',
            mechanics: '',
            laterality: '',
            primaryExerciseClassification: '',
          ),
        ];
        final expectedResult = Success<List<ExerciseEntity>>(allExercises);
        when(
          mockExerciseRepo.getExercisesByMuscleAndDifficulty(
            language: language,
            difficultyLevelId: difficultyLevelId,
            primeMoverMuscleId: primeMoverMuscleId,
          ),
        ).thenAnswer((_) async => expectedResult);

        // act
        final result = await getExercisesByMuscleAndDifficulty.call(
          language: language,
          difficultyLevelId: difficultyLevelId,
          primeMoverMuscleId: primeMoverMuscleId,
        );
        // Assert
        expect(result, isA<Success<List<ExerciseEntity>>>());

        expect(result, same(expectedResult));

        verify(
          mockExerciseRepo.getExercisesByMuscleAndDifficulty(
            language: language,
            difficultyLevelId: difficultyLevelId,
            primeMoverMuscleId: primeMoverMuscleId,
          ),
        ).called(1);
      },
    );
  });
}
