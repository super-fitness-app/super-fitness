import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/core/utils/password_generator.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/register_usecase.dart';
import 'package:super_fitness/features/auth/domain/use_cases/signin_with_google_usecase.dart';
import 'package:super_fitness/features/auth/presentation/register/manager/register_cubit.dart';

class FakeAuthRepo implements AuthRepo {
  ApiResults<RegisterEntity>? resultToReturn;
  RegisterParams? passedRequest;
  ApiResults<SocialAuthUserEntity>? googleResultToReturn;

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterParams request) async {
    passedRequest = request;
    return resultToReturn!;
  }

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() async {
    return googleResultToReturn!;
  }
}

void main() {
  group('RegisterCubit & Multi-step Registration Tests', () {
    late FakeAuthRepo fakeAuthRepo;
    late RegisterUseCase registerUseCase;
    late SignInWithGoogleUseCase googleUseCase;
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

    const testPasswordGenerator = PasswordGenerator.custom(
      secretKey: 'SuperFitnessSecretKey2026#',
      prefix: 'SuperFit@2026#',
    );

    setUp(() {
      fakeAuthRepo = FakeAuthRepo();
      registerUseCase = RegisterUseCase(fakeAuthRepo);
      googleUseCase = SignInWithGoogleUseCase(fakeAuthRepo);
      cubit = RegisterCubit(
        registerUseCase,
        googleUseCase,
        testPasswordGenerator,
      );
    });

    tearDown(() {
      cubit.close();
    });

    test('initial state has default RegisterData and initial registerState', () {
      expect(cubit.state.isLoading, isFalse);
      expect(cubit.state.failure, isNull);
      expect(cubit.state.data, equals(const RegisterData()));
      expect(cubit.state.registerState, equals(const BaseState.initial()));
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
        expect(cubit.state.data.firstName, 'John');
        expect(cubit.state.data.lastName, 'Doe');
        expect(cubit.state.data.email, 'john.doe@example.com');
        expect(cubit.state.data.password, 'Password123!');
        expect(cubit.state.data.rePassword, 'Password123!');
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

      expect(cubit.state.data.firstName, 'Jane');
      expect(cubit.state.data.lastName, 'Doe');
      expect(cubit.state.data.email, 'jane.doe@example.com');
      expect(cubit.state.data.password, 'Password123!');
      expect(cubit.state.data.rePassword, 'Password123!');
    });

    test('updateGenderIntent updates gender field in state', () {
      cubit.updateGenderIntent('male');
      expect(cubit.state.data.gender, 'male');
    });

    test('updateAgeIntent updates age field in state', () {
      cubit.updateAgeIntent(25);
      expect(cubit.state.data.age, 25);
    });

    test('updateWeightIntent updates weight field in state', () {
      cubit.updateWeightIntent(75);
      expect(cubit.state.data.weight, 75);
    });

    test('updateHeightIntent updates height field in state', () {
      cubit.updateHeightIntent(180);
      expect(cubit.state.data.height, 180);
    });

    test('updateGoalIntent updates goal field in state', () {
      cubit.updateGoalIntent('muscle');
      expect(cubit.state.data.goal, 'muscle');
    });

    test('updateActivityLevelIntent updates activityLevel field in state', () {
      cubit.updateActivityLevelIntent('intermediate');
      expect(cubit.state.data.activityLevel, 'intermediate');
    });

    test('resetRegistrationIntent resets state to initial with default data', () {
      cubit.updateGenderIntent('female');
      expect(cubit.state.data.gender, 'female');

      cubit.resetRegistrationIntent();
      expect(cubit.state.data, equals(const RegisterData()));
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

        await cubit.submitFinalRegistrationIntent();
        await Future.microtask(() {});

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

        await cubit.submitFinalRegistrationIntent();
        await Future.microtask(() {});

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

        await cubit.submitFinalRegistrationIntent();
        await Future.microtask(() {});

        expect(cubit.state.failure, isNotNull);
        expect(emittedEvents.any((e) => e is DisplayError), isTrue);

        await subscription.cancel();
      },
    );

    test(
      'SignInWithGoogleEvent success generates deterministic password and saves user data in Cubit state',
      () async {
        const googleUser = SocialAuthUserEntity(
          id: '12345',
          email: 'google.user@example.com',
          displayName: 'Jane Doe',
        );
        fakeAuthRepo.googleResultToReturn = const Success(googleUser);

        BaseEvent? receivedEvent;
        final sub = cubit.eventStream.listen((event) {
          receivedEvent = event;
        });

        await cubit.signInWithGoogleIntent();
        await Future.microtask(() {});

        final expectedPassword = testPasswordGenerator.generate('12345');
        expect(cubit.state.isLoading, isFalse);
        expect(cubit.state.data.email, 'google.user@example.com');
        expect(cubit.state.data.firstName, 'Jane');
        expect(cubit.state.data.lastName, 'Doe');
        expect(cubit.state.data.password, equals(expectedPassword));
        expect(cubit.state.data.rePassword, equals(expectedPassword));
        expect(receivedEvent, isA<DisplaySuccess>());

        await sub.cancel();
      },
    );

    test(
      'SignInWithGoogleEvent with null or empty ID emits error state and DisplayError',
      () async {
        const googleUser = SocialAuthUserEntity(
          id: null,
          email: 'google.user@example.com',
          displayName: 'Jane Doe',
        );
        fakeAuthRepo.googleResultToReturn = const Success(googleUser);

        BaseEvent? receivedEvent;
        final sub = cubit.eventStream.listen((event) {
          receivedEvent = event;
        });

        await cubit.signInWithGoogleIntent();
        await Future.microtask(() {});

        expect(cubit.state.isLoading, isFalse);
        expect(cubit.state.failure, isNotNull);
        expect(receivedEvent, isA<DisplayError>());

        await sub.cancel();
      },
    );

    test(
      'SignInWithGoogleEvent failure emits failure state and DisplayError',
      () async {
        fakeAuthRepo.googleResultToReturn = const Failure(
          ServerMessageFailure('Google sign-in was cancelled'),
        );

        BaseEvent? receivedEvent;
        final sub = cubit.eventStream.listen((event) {
          receivedEvent = event;
        });

        await cubit.signInWithGoogleIntent();
        await Future.microtask(() {});

        expect(cubit.state.isLoading, isFalse);
        expect(cubit.state.failure, isA<ServerMessageFailure>());
        expect(receivedEvent, isA<DisplayError>());

        await sub.cancel();
      },
    );

    test(
      'SignInWithGoogleEvent with CancelledFailure emits failure state and DisplayError with cancellation message',
      () async {
        fakeAuthRepo.googleResultToReturn = const Failure(
          CancelledFailure(AppStrings.signInCancelled),
        );

        BaseEvent? receivedEvent;
        final sub = cubit.eventStream.listen((event) {
          receivedEvent = event;
        });

        await cubit.signInWithGoogleIntent();
        await Future.microtask(() {});

        expect(cubit.state.isLoading, isFalse);
        expect(cubit.state.failure, isA<CancelledFailure>());
        expect(receivedEvent, isA<DisplayError>());
        final displayError = receivedEvent as DisplayError;
        expect(displayError.errorMsg, AppStrings.signInCancelled);
        expect(displayError.failure, isA<CancelledFailure>());

        await sub.cancel();
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

    test('isComplete and toParams / toDto validate full payload for API', () {
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
      final params = completeData.toParams();
      expect(params, isNotNull);
      expect(params?.firstName, 'John');
      expect(params?.height, 180);
      expect(params?.activityLevel, 'intermediate');

      final dto = completeData.toDto();
      expect(dto, isNotNull);
      expect(dto?.firstName, 'John');
      expect(dto?.height, 180);
      expect(dto?.activityLevel, 'intermediate');
    });
  });

  group('RegisterState Tests', () {
    test('supports value equality and copyWith correctly', () {
      const state1 = RegisterState();
      const state2 = RegisterState();
      expect(state1, equals(state2));

      final stateWithData = state1.copyWith(
        data: const RegisterData(firstName: 'John'),
      );
      expect(stateWithData.data.firstName, 'John');
      expect(stateWithData, isNot(equals(state1)));

      final loadingState = state1.copyWith(
        registerState: BaseState.loading(),
      );
      expect(loadingState.isLoading, isTrue);
      expect(loadingState.failure, isNull);

      final errorState = state1.copyWith(
        registerState: BaseState.error('Failed'),
      );
      expect(errorState.isLoading, isFalse);
      expect(errorState.failure, isNotNull);
    });
  });

  group('RegisterEvent Equatable Tests', () {
    test('subclasses support value equality correctly', () {
      expect(
        const SubmitBasicInfoEvent(
          firstName: 'John',
          lastName: 'Doe',
          email: 'j@d.com',
          password: 'pass',
        ),
        equals(
          const SubmitBasicInfoEvent(
            firstName: 'John',
            lastName: 'Doe',
            email: 'j@d.com',
            password: 'pass',
          ),
        ),
      );
      expect(
        const UpdateGenderEvent('male'),
        equals(const UpdateGenderEvent('male')),
      );
      expect(
        const UpdateAgeEvent(25),
        equals(const UpdateAgeEvent(25)),
      );
      expect(
        const UpdateWeightEvent(70),
        equals(const UpdateWeightEvent(70)),
      );
      expect(
        const UpdateHeightEvent(175),
        equals(const UpdateHeightEvent(175)),
      );
      expect(
        const UpdateGoalEvent('muscle'),
        equals(const UpdateGoalEvent('muscle')),
      );
      expect(
        const UpdateActivityLevelEvent('high'),
        equals(const UpdateActivityLevelEvent('high')),
      );
      expect(
        const SubmitFinalRegistrationEvent(),
        equals(const SubmitFinalRegistrationEvent()),
      );
      expect(
        const ResetRegistrationEvent(),
        equals(const ResetRegistrationEvent()),
      );
      expect(
        const SignInWithGoogleEvent(),
        equals(const SignInWithGoogleEvent()),
      );
    });
  });
}
