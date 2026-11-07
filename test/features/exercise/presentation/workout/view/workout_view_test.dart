import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/presentation/workout/manager/workout_cubit.dart';
import 'package:super_fitness/features/exercise/presentation/workout/view/workout_view.dart';
import 'package:super_fitness/features/exercise/presentation/workout/view/widgets/workout_muscle_card.dart';

class MockWorkoutCubit extends MockCubit<WorkoutState>
    implements WorkoutCubit {}

void main() {
  late MockWorkoutCubit cubit;

  setUp(() {
    cubit = MockWorkoutCubit();

    when(
      () => cubit.eventStream,
    ).thenAnswer((_) => const Stream<BaseEvent>.empty());

    when(() => cubit.close()).thenAnswer((_) async {});
  });

  Widget createWidget() {
    return MaterialApp(home: WorkoutView(cubit: cubit));
  }

  group('WorkoutView Widget Tests', () {
    testWidgets('should display loading indicator when loading', (
      tester,
    ) async {
      // Arrange
      final state = BaseState<WorkoutData>.loading(data: const WorkoutData());

      when(() => cubit.state).thenReturn(state);

      whenListen(
        cubit,
        const Stream<WorkoutState>.empty(),
        initialState: state,
      );

      // Act
      await tester.pumpWidget(createWidget());

      // Assert
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('should display empty message when muscles are empty', (
      tester,
    ) async {
      // Arrange
      final state = BaseState<WorkoutData>.success(const WorkoutData());

      when(() => cubit.state).thenReturn(state);

      whenListen(
        cubit,
        const Stream<WorkoutState>.empty(),
        initialState: state,
      );

      // Act
      await tester.pumpWidget(createWidget());

      // Assert
      expect(find.text('No exercises found'), findsOneWidget);
    });

    testWidgets('should display muscles when data is available', (
      tester,
    ) async {
      // Arrange
      const muscle = MuscleEntity(
        id: 'muscle-1',
        name: 'Rectus Abdominis',
        image: '',
      );

      final state = BaseState<WorkoutData>.success(
        const WorkoutData(muscles: [muscle]),
      );

      when(() => cubit.state).thenReturn(state);

      whenListen(
        cubit,
        const Stream<WorkoutState>.empty(),
        initialState: state,
      );

      // Act
      await tester.pumpWidget(createWidget());

      // Assert
      expect(find.text('No exercises found'), findsNothing);
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.byType(WorkoutMuscleCard), findsOneWidget);
    });

    testWidgets('should display error message when request fails', (
      tester,
    ) async {
      // Arrange
      final state = BaseState<WorkoutData>.error(
        'Something went wrong',
        data: const WorkoutData(),
      );

      when(() => cubit.state).thenReturn(state);

      whenListen(
        cubit,
        const Stream<WorkoutState>.empty(),
        initialState: state,
      );

      // Act
      await tester.pumpWidget(createWidget());

      // Assert
      expect(find.text('Something went wrong'), findsOneWidget);
    });
  });
}
