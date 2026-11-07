import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/exercise/domain/use_cases/get_muscle_groups_use_case.dart';
import 'package:super_fitness/features/exercise/domain/use_cases/get_muscles_by_group_use_case.dart';
import 'package:super_fitness/features/exercise/presentation/workout/manager/workout_cubit.dart';

class MockGetMuscleGroupsUseCase extends Mock
    implements GetMuscleGroupsUseCase {}

class MockGetMusclesByGroupUseCase extends Mock
    implements GetMusclesByGroupUseCase {}

void main() {
  late WorkoutCubit cubit;
  late MockGetMuscleGroupsUseCase getMuscleGroupsUseCase;
  late MockGetMusclesByGroupUseCase getMusclesByGroupUseCase;

  const muscleGroup1 = MuscleGroupEntity(id: 'group-1', name: 'Abdominals');

  const muscleGroup2 = MuscleGroupEntity(id: 'group-2', name: 'Arms');

  const muscle1 = MuscleEntity(
    id: 'muscle-1',
    name: 'Rectus Abdominis',
    image: '',
  );

  const muscle2 = MuscleEntity(id: 'muscle-2', name: 'Obliques', image: '');

  setUp(() {
    getMuscleGroupsUseCase = MockGetMuscleGroupsUseCase();
    getMusclesByGroupUseCase = MockGetMusclesByGroupUseCase();

    cubit = WorkoutCubit(getMuscleGroupsUseCase, getMusclesByGroupUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('WorkoutCubit', () {
    test('initial state should be empty', () {
      expect(cubit.state.isLoading, false);
      expect(cubit.state.data, null);
      expect(cubit.state.failure, null);
    });

    blocTest<WorkoutCubit, WorkoutState>(
      'should fetch muscle groups and muscles of the first group',
      build: () {
        when(
          () => getMuscleGroupsUseCase(),
        ).thenAnswer((_) async => const Success([muscleGroup1, muscleGroup2]));

        when(
          () => getMusclesByGroupUseCase('group-1'),
        ).thenAnswer((_) async => const Success([muscle1, muscle2]));

        return cubit;
      },
      act: (cubit) {
        cubit.doEvent(const FetchMuscleGroupsEvent());
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<WorkoutState>().having((state) => state.isLoading, 'loading', true),
        isA<WorkoutState>()
            .having((state) => state.data?.groups.length, 'groups count', 2)
            .having(
              (state) => state.data?.selectedGroupId,
              'selected group',
              'group-1',
            ),
        isA<WorkoutState>().having(
          (state) => state.isLoading,
          'loading muscles',
          true,
        ),
        isA<WorkoutState>()
            .having((state) => state.data?.muscles.length, 'muscles count', 2)
            .having(
              (state) => state.data?.muscles.first.name,
              'first muscle',
              'Rectus Abdominis',
            ),
      ],
      verify: (_) {
        verify(() => getMuscleGroupsUseCase()).called(1);
        verify(() => getMusclesByGroupUseCase('group-1')).called(1);
      },
    );

    blocTest<WorkoutCubit, WorkoutState>(
      'should fetch muscles when selecting another group',
      build: () {
        when(
          () => getMuscleGroupsUseCase(),
        ).thenAnswer((_) async => const Success([muscleGroup1, muscleGroup2]));

        when(
          () => getMusclesByGroupUseCase('group-1'),
        ).thenAnswer((_) async => const Success([muscle1]));

        when(
          () => getMusclesByGroupUseCase('group-2'),
        ).thenAnswer((_) async => const Success([muscle2]));

        return cubit;
      },
      act: (cubit) async {
        cubit.doEvent(const FetchMuscleGroupsEvent());

        await Future<void>.delayed(const Duration(milliseconds: 100));

        cubit.doEvent(const SelectMuscleGroupEvent('group-2'));
      },
      wait: const Duration(milliseconds: 100),
      expect: () => [
        isA<WorkoutState>().having((state) => state.isLoading, 'loading', true),
        isA<WorkoutState>().having(
          (state) => state.data?.selectedGroupId,
          'group',
          'group-1',
        ),
        isA<WorkoutState>().having(
          (state) => state.isLoading,
          'loading muscles',
          true,
        ),
        isA<WorkoutState>().having(
          (state) => state.data?.muscles.length,
          'muscles',
          1,
        ),
        isA<WorkoutState>()
            .having((state) => state.isLoading, 'loading', true)
            .having((state) => state.data?.selectedGroupId, 'group', 'group-2'),
        isA<WorkoutState>().having(
          (state) => state.data?.muscles.first.name,
          'muscle',
          'Obliques',
        ),
      ],
      verify: (_) {
        verify(() => getMusclesByGroupUseCase('group-1')).called(1);
        verify(() => getMusclesByGroupUseCase('group-2')).called(1);
      },
    );

    test(
      'should not fetch the same group again when muscles already exist',
      () async {
        when(
          () => getMuscleGroupsUseCase(),
        ).thenAnswer((_) async => const Success([muscleGroup1]));

        when(
          () => getMusclesByGroupUseCase('group-1'),
        ).thenAnswer((_) async => const Success([muscle1]));

        cubit.doEvent(const FetchMuscleGroupsEvent());

        await Future<void>.delayed(const Duration(milliseconds: 100));

        cubit.doEvent(const SelectMuscleGroupEvent('group-1'));

        await Future<void>.delayed(const Duration(milliseconds: 50));

        verify(() => getMusclesByGroupUseCase('group-1')).called(1);
      },
    );
  });
}
