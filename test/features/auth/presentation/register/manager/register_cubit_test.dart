import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/register_usecase.dart';
import 'package:super_fitness/features/auth/presentation/register/manager/register_cubit.dart';

class FakeAuthRepo implements AuthRepo {
  ApiResults<RegisterEntity>? resultToReturn;
  RegisterDto? passedRequest;

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterDto request) async {
    passedRequest = request;
    return resultToReturn!;
  }
}

void main() {
  group('RegisterCubit & Multi-step Registration Tests', () {
    late FakeAuthRepo fakeAuthRepo;
    late RegisterUseCase registerUseCase;
    late RegisterCubit cubit;

    const testEntity = RegisterEntity(
      message: 'success',
      token: 'test_token',
      user: UserEntity(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
      ),
    );

    setUp(() {
      fakeAuthRepo = FakeAuthRepo();
      registerUseCase = RegisterUseCase(fakeAuthRepo);
      cubit = RegisterCubit(registerUseCase);
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state uses BaseState.initial with null data', () {
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.failure, isNull);
      expect(cubit.state.data, isNull);
    });

    test(
      'doEvent with SubmitBasicInfoEvent updates state.data in MVI flow',
      () {
        cubit.doEvent(
          const SubmitBasicInfoEvent(
            firstName: 'John',
            lastName: 'Doe',
            email: 'john.doe@example.com',
            password: 'Password123!',
          ),
        );

        expect(cubit.state.isLoading, isFalse);
        expect(cubit.state.data?.firstName, 'John');
        expect(cubit.state.data?.lastName, 'Doe');
        expect(cubit.state.data?.email, 'john.doe@example.com');
        expect(cubit.state.data?.password, 'Password123!');
        expect(cubit.state.data?.rePassword, 'Password123!');
      },
    );

    test('submitBasicInfoIntent updates basic info through doEvent', () {
      cubit.submitBasicInfoIntent(
        firstName: 'Jane',
        lastName: 'Doe',
        email: 'jane.doe@example.com',
        password: 'Password123!',
        rePassword: 'Password123!',
      );

      expect(cubit.state.data?.firstName, 'Jane');
      expect(cubit.state.data?.lastName, 'Doe');
      expect(cubit.state.data?.email, 'jane.doe@example.com');
      expect(cubit.state.data?.password, 'Password123!');
      expect(cubit.state.data?.rePassword, 'Password123!');
    });

    test('updateGenderIntent updates gender field in state', () {
      cubit.updateGenderIntent('male');
      expect(cubit.state.data?.gender, 'male');
    });

    test('updateAgeIntent updates age field in state', () {
      cubit.updateAgeIntent(25);
      expect(cubit.state.data?.age, 25);
    });

    test('updateWeightIntent updates weight field in state', () {
      cubit.updateWeightIntent(75);
      expect(cubit.state.data?.weight, 75);
    });

    test('updateHeightIntent updates height field in state', () {
      cubit.updateHeightIntent(180);
      expect(cubit.state.data?.height, 180);
    });

    test('updateGoalIntent updates goal field in state', () {
      cubit.updateGoalIntent('muscle');
      expect(cubit.state.data?.goal, 'muscle');
    });

    test('updateActivityLevelIntent updates activityLevel field in state', () {
      cubit.updateActivityLevelIntent('intermediate');
      expect(cubit.state.data?.activityLevel, 'intermediate');
    });

    test('resetRegistrationIntent resets state to initial with null data', () {
      cubit.updateGenderIntent('female');
      expect(cubit.state.data?.gender, 'female');

      cubit.resetRegistrationIntent();
      expect(cubit.state.data, isNull);
      expect(cubit.state.isLoading, isFalse);
    });

    test(
      'submitFinalRegistration emits error when data is incomplete',
      () async {
        final emittedEvents = <BaseEvent>[];
        final subscription = cubit.eventStream.listen(emittedEvents.add);

        cubit.submitBasicInfoIntent(
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
          password: 'Password123!',
        );

        cubit.submitFinalRegistrationIntent();
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.failure, isNotNull);
        expect(emittedEvents.any((e) => e is DisplayError), isTrue);

        await subscription.cancel();
      },
    );

    test(
      'submitFinalRegistration successfully calls API and emits success event when data is complete',
      () async {
        fakeAuthRepo.resultToReturn = const Success(testEntity);
        final emittedEvents = <BaseEvent>[];
        final subscription = cubit.eventStream.listen(emittedEvents.add);

        // Fill all 7 steps
        cubit.submitBasicInfoIntent(
          firstName: 'John',
          lastName: 'Doe',
          email: 'john.doe@example.com',
          password: 'Password123!',
        );
        cubit.updateGenderIntent('male');
        cubit.updateAgeIntent(25);
        cubit.updateWeightIntent(75);
        cubit.updateHeightIntent(180);
        cubit.updateGoalIntent('muscle');
        cubit.updateActivityLevelIntent('intermediate');

        cubit.submitFinalRegistrationIntent();
        await Future<void>.delayed(Duration.zero);

        expect(fakeAuthRepo.passedRequest?.email, 'john.doe@example.com');
        expect(fakeAuthRepo.passedRequest?.height, 180);
        expect(cubit.state.isLoading, isFalse);
        expect(emittedEvents.any((e) => e is DisplaySuccess), isTrue);

        await subscription.cancel();
      },
    );

    test(
      'submitFinalRegistration handles API failure and emits DisplayError event',
      () async {
        fakeAuthRepo.resultToReturn = const FailureResponse(
          ServerMessageFailure('Email already exists'),
        );
        final emittedEvents = <BaseEvent>[];
        final subscription = cubit.eventStream.listen(emittedEvents.add);

        cubit.submitBasicInfoIntent(
          firstName: 'John',
          lastName: 'Doe',
          email: 'john.doe@example.com',
          password: 'Password123!',
        );
        cubit.updateGenderIntent('male');
        cubit.updateAgeIntent(25);
        cubit.updateWeightIntent(75);
        cubit.updateHeightIntent(180);
        cubit.updateGoalIntent('muscle');
        cubit.updateActivityLevelIntent('intermediate');

        cubit.submitFinalRegistrationIntent();
        await Future<void>.delayed(Duration.zero);

        expect(cubit.state.failure, isNotNull);
        expect(emittedEvents.any((e) => e is DisplayError), isTrue);

        await subscription.cancel();
      },
    );
  });

  group('RegisterData Model Tests', () {
    test(
      'copyWith preserves existing data across incremental multi-step updates',
      () {
        const initial = RegisterData(
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
        );

        final updatedWithGender = initial.copyWith(gender: 'male');
        final updatedWithHeightAndWeight = updatedWithGender.copyWith(
          height: 180,
          weight: 75,
        );

        expect(updatedWithHeightAndWeight.firstName, 'John');
        expect(updatedWithHeightAndWeight.lastName, 'Doe');
        expect(updatedWithHeightAndWeight.email, 'john@example.com');
        expect(updatedWithHeightAndWeight.gender, 'male');
        expect(updatedWithHeightAndWeight.height, 180);
        expect(updatedWithHeightAndWeight.weight, 75);
      },
    );

    test('isBasicInfoComplete validates Step 1 fields correctly', () {
      const incomplete = RegisterData(firstName: 'John');
      expect(incomplete.isBasicInfoComplete, isFalse);

      const complete = RegisterData(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        password: 'Password123!',
      );
      expect(complete.isBasicInfoComplete, isTrue);
    });

    test('isComplete and toDto validate full payload for API', () {
      const completeData = RegisterData(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john@example.com',
        password: 'Password123!',
        gender: 'male',
        height: 180,
        weight: 75,
        age: 25,
        goal: 'muscle',
        activityLevel: 'intermediate',
      );

      expect(completeData.isComplete, isTrue);
      final dto = completeData.toDto();
      expect(dto, isNotNull);
      expect(dto?.firstName, 'John');
      expect(dto?.height, 180);
      expect(dto?.activityLevel, 'intermediate');
    });
  });
}
