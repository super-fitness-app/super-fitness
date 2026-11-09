import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';
import 'package:super_fitness/features/ai_chat/data/database/fitness_database_manager.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/local/fitness_local_data_source_impl.dart';

class MockFitnessDatabaseManager extends Mock
    implements FitnessDatabaseManager {
  @override
  Future<Database> getDatabase([dynamic database]) =>
      super.noSuchMethod(
            Invocation.method(#getDatabase, [database]),
            returnValue: Future.value(MockDatabase()),
          )
          as Future<Database>;
}

class MockDatabase extends Mock implements Database {
  @override
  Future<List<Map<String, Object?>>> query(
    String? table, {
    bool? distinct,
    List<String>? columns,
    String? where,
    List<Object?>? whereArgs,
    String? groupBy,
    String? having,
    String? orderBy,
    int? limit,
    int? offset,
  }) =>
      super.noSuchMethod(
            Invocation.method(
              #query,
              [table],
              {
                #distinct: distinct,
                #columns: columns,
                #where: where,
                #whereArgs: whereArgs,
                #groupBy: groupBy,
                #having: having,
                #orderBy: orderBy,
                #limit: limit,
                #offset: offset,
              },
            ),
            returnValue: Future.value(<Map<String, Object?>>[]),
          )
          as Future<List<Map<String, Object?>>>;

  @override
  Future<List<Map<String, Object?>>> rawQuery(
    String? sql, [
    List<Object?>? arguments,
  ]) =>
      super.noSuchMethod(
            Invocation.method(#rawQuery, [sql, arguments]),
            returnValue: Future.value(<Map<String, Object?>>[]),
          )
          as Future<List<Map<String, Object?>>>;
}

void main() {
  late MockFitnessDatabaseManager mockDbManager;
  late MockDatabase mockDb;
  late FitnessLocalDataSourceImpl dataSource;

  setUp(() {
    mockDbManager = MockFitnessDatabaseManager();
    mockDb = MockDatabase();
    when(mockDbManager.getDatabase(any)).thenAnswer((_) async => mockDb);
    dataSource = FitnessLocalDataSourceImpl(mockDbManager);
  });

  group('FitnessLocalDataSourceImpl Tests', () {
    test(
      'searchMeals executes query with proper filters and returns mapped MealModels',
      () async {
        final sampleMealRow = <String, Object?>{
          'id': 'meal_1',
          'name': 'Oatmeal',
          'name_ar': 'شوفان',
          'category': 'Breakfast',
          'area': 'Global',
          'meal_type': 'Breakfast',
          'kcal': 250.0,
          'protein_g': 12.0,
          'carbs_g': 45.0,
          'fat_g': 5.0,
          'nutrition_is_estimate': 1,
          'nutrition_confidence': 0.9,
          'vegetarian': 1,
          'vegan': 1,
          'contains_gluten': 0,
          'contains_nuts': 0,
          'ingredient_count': 3,
          'thumb': null,
          'youtube': null,
          'tags': 'healthy',
          'popularity': 85,
        };

        when(
          mockDb.query(
            'meal_card',
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            orderBy: anyNamed('orderBy'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => [sampleMealRow]);

        final results = await dataSource.searchMeals(
          query: 'oat',
          minCalories: 200,
          maxCalories: 400,
          minProtein: 10,
        );

        expect(results.length, equals(1));
        expect(results.first.id, equals('meal_1'));
        expect(results.first.name, equals('oatmeal'));
        expect(results.first.nutritionIsEstimate, isTrue);
        expect(results.first.vegetarian, isTrue);

        verify(
          mockDb.query(
            'meal_card',
            where: argThat(
              allOf([
                contains('kcal >= ?'),
                contains('kcal <= ?'),
                contains('protein_g >= ?'),
              ]),
              named: 'where',
            ),
            whereArgs: argThat(
              allOf([contains(200.0), contains(400.0), contains(10.0)]),
              named: 'whereArgs',
            ),
            orderBy: 'popularity DESC, name ASC',
            limit: 50,
          ),
        ).called(1);
      },
    );

    test(
      'searchExercises executes query with muscle group and equipment filters',
      () async {
        final sampleExerciseRow = <String, Object?>{
          'id': 'ex_squat',
          'name': 'Barbell Squat',
          'muscle_group': 'Legs',
          'prime_mover': 'Quadriceps',
          'equipment': 'Barbell',
          'difficulty': 'Intermediate',
          'instructions': 'Squat deep.',
          'exercise_type': 'Strength',
          'mechanics': 'Compound',
          'target_gender': 'All',
          'tags': 'legs,quads',
          'popularity': 95,
        };

        when(
          mockDb.query(
            'exercise_card',
            where: anyNamed('where'),
            whereArgs: anyNamed('whereArgs'),
            orderBy: anyNamed('orderBy'),
            limit: anyNamed('limit'),
          ),
        ).thenAnswer((_) async => [sampleExerciseRow]);

        final results = await dataSource.searchExercises(
          muscleGroup: 'Legs',
          equipment: 'Barbell',
        );

        expect(results.length, equals(1));
        expect(results.first.id, equals('ex_squat'));
        expect(results.first.name, equals('barbell squat'));
        expect(results.first.primeMover, equals('Quadriceps'));

        verify(
          mockDb.query(
            'exercise_card',
            where: argThat(
              allOf([
                contains('muscle_group LIKE ?'),
                contains('equipment LIKE ?'),
              ]),
              named: 'where',
            ),
            whereArgs: anyNamed('whereArgs'),
            orderBy: 'popularity DESC, name ASC',
            limit: 100,
          ),
        ).called(1);
      },
    );

    test(
      'getMealById returns MealModel when found or null when empty',
      () async {
        when(
          mockDb.query(
            'meal_card',
            where: 'id = ?',
            whereArgs: ['missing'],
            limit: 1,
          ),
        ).thenAnswer((_) async => []);

        final result = await dataSource.getMealById('missing');
        expect(result, isNull);
      },
    );

    test(
      'getExerciseById returns ExerciseModel when found or null when empty',
      () async {
        when(
          mockDb.query(
            'exercise_card',
            where: 'id = ?',
            whereArgs: ['missing'],
            limit: 1,
          ),
        ).thenAnswer((_) async => []);

        final result = await dataSource.getExerciseById('missing');
        expect(result, isNull);
      },
    );
  });
}
