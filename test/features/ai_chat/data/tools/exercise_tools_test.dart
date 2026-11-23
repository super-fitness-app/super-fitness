import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/contract/fitness_local_data_source.dart';
import 'package:super_fitness/features/ai_chat/data/models/exercise_model.dart';
import 'package:super_fitness/features/ai_chat/data/tools/exercise/exercise_tools.dart';

class MockFitnessLocalDataSource extends Mock
    implements FitnessLocalDataSource {
  @override
  Future<List<ExerciseModel>> searchExercises({
    String? query,
    String? muscleGroup,
    String? difficulty,
    String? equipment,
  }) =>
      super.noSuchMethod(
            Invocation.method(#searchExercises, [], {
              #query: query,
              #muscleGroup: muscleGroup,
              #difficulty: difficulty,
              #equipment: equipment,
            }),
            returnValue: Future.value(<ExerciseModel>[]),
          )
          as Future<List<ExerciseModel>>;

  @override
  Future<ExerciseModel?> getExerciseById(String? id) =>
      super.noSuchMethod(
            Invocation.method(#getExerciseById, [id]),
            returnValue: Future.value(null),
          )
          as Future<ExerciseModel?>;
}

void main() {
  late MockFitnessLocalDataSource mockDataSource;
  late ExerciseTools tools;

  setUp(() {
    mockDataSource = MockFitnessLocalDataSource();
    tools = ExerciseTools(mockDataSource);
  });

  group('ExerciseTools Tests', () {
    test('searchExercises returns success and exercise list', () async {
      when(
        mockDataSource.searchExercises(query: anyNamed('query')),
      ).thenAnswer((_) async => []);

      final res = await tools.searchExercises({'query': 'bench'});
      expect(res['success'], isTrue);
      expect(res['data']['count'], equals(0));
    });

    test(
      'getExerciseDetails returns error when exercise_id is missing',
      () async {
        final res = await tools.getExerciseDetails({});
        expect(res['success'], isFalse);
        expect(res['error'], contains('Exercise ID is required'));
      },
    );

    test(
      'getExerciseDetails returns error when exercise is not found',
      () async {
        when(mockDataSource.getExerciseById(any)).thenAnswer((_) async => null);

        final res = await tools.getExerciseDetails({
          'exercise_id': 'invalid_id',
        });
        expect(res['success'], isFalse);
        expect(res['error'], contains('Exercise not found'));
      },
    );
  });
}
