import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:network_image_mock/network_image_mock.dart';

import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
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

  late MockGetAllDfficultyLevelsUseCase mockGetLevels;
  late MockGetExercisesByMuscleAndDfficultyUseCase mockGetExercises;
  late ExerciseCubit cubit;

  const muscle = MuscleEntity(
    id: 'muscle_1',
    name: 'Rectus Abdominis',
    image: 'https://example.com/muscle.png',
  );

  const levels = [
    DifficultyLevelEntity(id: 'level_1', name: 'Beginner'),
    DifficultyLevelEntity(id: 'level_2', name: 'Intermediate'),
    DifficultyLevelEntity(id: 'level_3', name: 'Advanced'),
  ];

  setUp(() {
    mockGetLevels = MockGetAllDfficultyLevelsUseCase();
    mockGetExercises = MockGetExercisesByMuscleAndDfficultyUseCase();

    cubit = ExerciseCubit(mockGetExercises, mockGetLevels);

    when(
      mockGetLevels.call(language: 'en'),
    ).thenAnswer((_) async => Success(levels));

    when(
      mockGetExercises.call(
        language: anyNamed('language'),
        difficultyLevelId: anyNamed('difficultyLevelId'),
        primeMoverMuscleId: anyNamed('primeMoverMuscleId'),
      ),
    ).thenAnswer((_) async => const Success<List<ExerciseEntity>>([]));
  });

  tearDown(() async {
    await cubit.close();
  });

  Widget createWidget() {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: ExerciseView(cubit: cubit, muscle: muscle),
    );
  }

  group('ExerciseView Widget Tests', () {
    testWidgets('should display selected muscle name', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidget());
        await tester.pump();
      });

      expect(find.text('Rectus Abdominis'), findsOneWidget);
    });

    testWidgets('should display difficulty tabs', (tester) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidget());
        await tester.pump();
      });

      expect(find.byType(TabBar), findsOneWidget);
    });

    testWidgets('should request difficulty levels on initialization', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidget());
        await tester.pump();
      });

      verify(mockGetLevels.call(language: 'en')).called(1);
    });

    testWidgets('should pass selected muscle ID when loading exercises', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidget());
        await tester.pump();
        await tester.pump();
      });

      verify(
        mockGetExercises.call(
          language: 'en',
          difficultyLevelId: 'level_1',
          primeMoverMuscleId: 'muscle_1',
        ),
      ).called(1);
    });

    testWidgets('should display no exercises message when list is empty', (
      tester,
    ) async {
      await mockNetworkImagesFor(() async {
        await tester.pumpWidget(createWidget());
        await tester.pump();
        await tester.pump();
      });

      expect(
        find.text(
          AppLocalizations.of(
            tester.element(find.byType(ExerciseView)),
          )!.noExercisesFound,
        ),
        findsOneWidget,
      );
    });
  });
}
