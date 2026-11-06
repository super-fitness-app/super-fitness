import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/core/ui/themes/app_theme.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';
import 'package:super_fitness/features/exercise/domain/use_case/get_muscle_groups_use_case.dart';
import 'package:super_fitness/features/exercise/domain/use_case/get_muscles_by_group_use_case.dart';
import 'package:super_fitness/features/exercise/presentation/workout/manager/workout_cubit.dart';
import 'package:super_fitness/features/exercise/presentation/workout/view/workout_view.dart';

class FakeExerciseRepo implements ExerciseRepo {
  ApiResults<List<MuscleGroupEntity>> groupsResult = const Success([]);
  ApiResults<List<MuscleEntity>> musclesResult = const Success([]);

  @override
  Future<ApiResults<List<MuscleGroupEntity>>> getMuscleGroups() async =>
      groupsResult;

  @override
  Future<ApiResults<List<MuscleEntity>>> getMusclesByGroup(
    String groupId,
  ) async => musclesResult;
}

Widget buildTestWidget(WorkoutCubit cubit) {
  return MaterialApp(
    theme: AppTheme.darkTheme,
    home: WorkoutView(cubit: cubit),
  );
}

void main() {
  late FakeExerciseRepo repo;
  late WorkoutCubit cubit;

  setUp(() {
    repo = FakeExerciseRepo();
    cubit = WorkoutCubit(
      GetMuscleGroupsUseCase(repo),
      GetMusclesByGroupUseCase(repo),
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  testWidgets('renders title and loading state initially', (tester) async {
    await tester.pumpWidget(buildTestWidget(cubit));
    expect(find.text('Workouts'), findsOneWidget);
  });

  testWidgets('renders muscle groups and muscle cards on success', (
    tester,
  ) async {
    repo.groupsResult = const Success([
      MuscleGroupEntity(id: '1', name: 'Chest'),
      MuscleGroupEntity(id: '2', name: 'Back'),
    ]);
    repo.musclesResult = const Success([
      MuscleEntity(id: 'm1', name: 'Pectoralis Major', image: ''),
    ]);

    await tester.pumpWidget(buildTestWidget(cubit));
    await tester.pumpAndSettle();

    expect(find.text('Workouts'), findsOneWidget);
    expect(find.text('Chest'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
    expect(find.text('Pectoralis Major'), findsOneWidget);
  });

  testWidgets('renders empty state when muscles list is empty', (tester) async {
    repo.groupsResult = const Success([
      MuscleGroupEntity(id: '1', name: 'Chest'),
    ]);
    repo.musclesResult = const Success([]);

    await tester.pumpWidget(buildTestWidget(cubit));
    await tester.pumpAndSettle();

    expect(find.text('No exercises found'), findsOneWidget);
  });

  testWidgets('renders error message when fetching fails', (tester) async {
    repo.groupsResult = const FailureResponse(
      ServerMessageFailure('Server error'),
    );

    await tester.pumpWidget(buildTestWidget(cubit));
    await tester.pumpAndSettle();

    expect(find.text('Server error'), findsWidgets);
  });

  testWidgets('tapping filter chip selects new group', (tester) async {
    repo.groupsResult = const Success([
      MuscleGroupEntity(id: '1', name: 'Chest'),
      MuscleGroupEntity(id: '2', name: 'Back'),
    ]);
    repo.musclesResult = const Success([
      MuscleEntity(id: 'm1', name: 'Pectoralis', image: ''),
    ]);

    await tester.pumpWidget(buildTestWidget(cubit));
    await tester.pumpAndSettle();

    repo.musclesResult = const Success([
      MuscleEntity(id: 'm2', name: 'Latissimus', image: ''),
    ]);

    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    expect(find.text('Latissimus'), findsOneWidget);
  });
}
