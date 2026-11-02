import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/config/network/api_results.dart';

import 'package:super_fitness/features/exercise/domain/entities/difficulty_level_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/exercise_entity.dart';

import 'package:super_fitness/features/exercise/domain/use_cases/get_all_dfficulty_levels_use_case.dart';
import 'package:super_fitness/features/exercise/domain/use_cases/get_exercises_by_muscle_and_dfficulty_use_case.dart';

import 'package:super_fitness/features/exercise/presentation/exercise/manager/exercise_cubit.dart';
import 'package:super_fitness/features/exercise/presentation/exercise/view/exercise_view.dart';

import 'exercise_view_test.mocks.dart';

@GenerateMocks([
  GetAllDfficultyLevelsUseCase,
  GetExercisesByMuscleAndDfficultyUseCase,
])
void main() {
  provideDummy<ApiResults<List<DifficultyLevelEntity>>>(
    Success<List<DifficultyLevelEntity>>([]),
  );

  provideDummy<ApiResults<List<ExerciseEntity>>>(
    Success<List<ExerciseEntity>>([]),
  );

  late MockGetAllDfficultyLevelsUseCase mockGetAllDifficultyLevels;
  late MockGetExercisesByMuscleAndDfficultyUseCase mockGetExercises;
  late ExerciseCubit cubit;

  const language = 'en';

  const levels = [
    DifficultyLevelEntity(id: 'level_1', name: 'Beginner'),
    DifficultyLevelEntity(id: 'level_2', name: 'Intermediate'),
    DifficultyLevelEntity(id: 'level_3', name: 'Advanced'),
  ];

  const primeMoverMuscleId = '69d982ef85f6bfa972bf2248';

  setUp(() {
    mockGetAllDifficultyLevels = MockGetAllDfficultyLevelsUseCase();
    mockGetExercises = MockGetExercisesByMuscleAndDfficultyUseCase();

    cubit = ExerciseCubit(mockGetExercises, mockGetAllDifficultyLevels);
  });

  tearDown(() async {
    await cubit.close();
  });

  Widget createWidget() {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ExerciseView(cubit: cubit),
    );
  }

  group('ExerciseView Widget Tests', () {
    testWidgets(
      'should display loading indicator while difficulty levels are loading',
      (tester) async {
        // Arrange
        final completer = Completer<ApiResults<List<DifficultyLevelEntity>>>();

        when(
          mockGetAllDifficultyLevels.call(language: language),
        ).thenAnswer((_) => completer.future);

        // Act
        await tester.pumpWidget(createWidget());
        await tester.pump();

        // Assert
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        // Complete the pending request to avoid leaving it unfinished.
        completer.complete(Success<List<DifficultyLevelEntity>>([]));

        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'should display difficulty tabs after levels load successfully',
      (tester) async {
        // Arrange
        when(
          mockGetAllDifficultyLevels.call(language: language),
        ).thenAnswer((_) async => Success<List<DifficultyLevelEntity>>(levels));

        // Act
        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        // Assert
        expect(find.byType(TabBar), findsOneWidget);
        expect(find.text('Beginner'), findsOneWidget);
        expect(find.text('Intermediate'), findsOneWidget);
        expect(find.text('Advanced'), findsOneWidget);
      },
    );

    testWidgets(
      'should display no exercises message when exercise list is empty',
      (tester) async {
        // Arrange
        when(
          mockGetAllDifficultyLevels.call(language: language),
        ).thenAnswer((_) async => Success<List<DifficultyLevelEntity>>(levels));

        // Act
        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        // Assert
        final localization = AppLocalizations.of(
          tester.element(find.byType(Scaffold)),
        )!;

        expect(find.text(localization.noExercisesFound), findsOneWidget);
      },
    );

    testWidgets(
      'should request exercises when user selects another difficulty tab',
      (tester) async {
        // Arrange
        when(
          mockGetAllDifficultyLevels.call(language: language),
        ).thenAnswer((_) async => Success<List<DifficultyLevelEntity>>(levels));

        when(
          mockGetExercises.call(
            language: language,
            difficultyLevelId: 'level_2',
            primeMoverMuscleId: primeMoverMuscleId,
          ),
        ).thenAnswer((_) async => Success<List<ExerciseEntity>>([]));

        // Act
        await tester.pumpWidget(createWidget());
        await tester.pumpAndSettle();

        await tester.tap(find.text('Intermediate'));
        await tester.pumpAndSettle();

        // Assert
        verify(
          mockGetExercises.call(
            language: language,
            difficultyLevelId: 'level_2',
            primeMoverMuscleId: primeMoverMuscleId,
          ),
        ).called(1);
      },
    );
  });
}
