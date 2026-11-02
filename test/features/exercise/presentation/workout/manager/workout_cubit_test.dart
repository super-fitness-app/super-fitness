import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/core/errors/app_failure.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_entity.dart';
import 'package:super_fitness/features/exercise/domain/entities/muscle_group_entity.dart';
import 'package:super_fitness/features/exercise/domain/repo/exercise_repo.dart';
import 'package:super_fitness/features/exercise/domain/use_case/get_muscle_groups_use_case.dart';
import 'package:super_fitness/features/exercise/domain/use_case/get_muscles_by_group_use_case.dart';
import 'package:super_fitness/features/exercise/presentation/workout/manager/workout_cubit.dart';

class FakeExerciseRepo implements ExerciseRepo {
  ApiResults<List<MuscleGroupEntity>> groupsResult = const Success([]);
  ApiResults<List<MuscleEntity>> musclesResult = const Success([]);

  @override
  Future<ApiResults<List<MuscleGroupEntity>>> getMuscleGroups() async =>
      groupsResult;

  @override
  Future<ApiResults<List<MuscleEntity>>> getMusclesByGroup(
    String groupId,
  ) async =>
      musclesResult;
}

void main() {
  late FakeExerciseRepo fakeRepo;
  late GetMuscleGroupsUseCase getGroupsUseCase;
  late GetMusclesByGroupUseCase getMusclesUseCase;
  late WorkoutCubit cubit;

  const mockGroups = [
    MuscleGroupEntity(id: '1', name: 'Chest'),
    MuscleGroupEntity(id: '2', name: 'Shoulders'),
  ];

  const mockMuscles = [
    MuscleEntity(id: 'm1', name: 'Pectoralis Major', image: 'img_url'),
  ];

  setUp(() {
    fakeRepo = FakeExerciseRepo();
    getGroupsUseCase = GetMuscleGroupsUseCase(fakeRepo);
    getMusclesUseCase = GetMusclesByGroupUseCase(fakeRepo);
    cubit = WorkoutCubit(getGroupsUseCase, getMusclesUseCase);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('initial state has empty data and not loading', () {
    expect(cubit.state, const BaseState<WorkoutData>.initial());
  });

  test('FetchMuscleGroupsEvent success populates groups and fetches muscles for first group', () async {
    fakeRepo.groupsResult = const Success(mockGroups);
    fakeRepo.musclesResult = const Success(mockMuscles);

    cubit.doEvent(const FetchMuscleGroupsEvent());
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.isLoading, false);
    expect(cubit.state.data?.groups, mockGroups);
    expect(cubit.state.data?.selectedGroupId, '1');
    expect(cubit.state.data?.muscles, mockMuscles);
  });

  test('FetchMuscleGroupsEvent failure emits error event and failure state', () async {
    const failure = ServerMessageFailure('Failed to fetch groups');
    fakeRepo.groupsResult = const FailureResponse(failure);

    final emittedEvents = <BaseEvent>[];
    final subscription = cubit.eventStream.listen(emittedEvents.add);

    cubit.doEvent(const FetchMuscleGroupsEvent());
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.failure, failure);
    expect(emittedEvents.length, 1);
    expect(emittedEvents.first, isA<DisplayError>());

    await subscription.cancel();
  });

  test('SelectMuscleGroupEvent updates selectedGroupId and loads muscles', () async {
    fakeRepo.groupsResult = const Success(mockGroups);
    fakeRepo.musclesResult = const Success(mockMuscles);

    cubit.doEvent(const SelectMuscleGroupEvent('2'));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.data?.selectedGroupId, '2');
    expect(cubit.state.data?.muscles, mockMuscles);
  });

  test('SelectMuscleGroupEvent handles null image safely', () async {
    const musclesWithNullImage = [
      MuscleEntity(id: 'm2', name: 'Medial Deltoids', image: ''),
    ];
    fakeRepo.musclesResult = const Success(musclesWithNullImage);

    cubit.doEvent(const SelectMuscleGroupEvent('2'));
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.data?.muscles.first.image, '');
    expect(cubit.state.failure, isNull);
  });
}
