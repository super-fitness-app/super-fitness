import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/register_usecase.dart';

class FakeAuthRepo implements AuthRepo {
  ApiResults<RegisterEntity>? resultToReturn;
  RegisterParams? passedRequest;

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterParams request) async {
    passedRequest = request;
    return resultToReturn!;
  }

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() async {
    throw UnimplementedError();
  }

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params) async {
    throw UnimplementedError();
  }
}

void main() {
  group('RegisterUseCase Tests', () {
    late FakeAuthRepo fakeAuthRepo;
    late RegisterUseCase registerUseCase;

    const testParams = RegisterParams(
      firstName: 'John',
      lastName: 'Doe',
      email: 'john.doe@example.com',
      password: 'Password123!',
      rePassword: 'Password123!',
      gender: 'male',
      height: 180,
      weight: 75,
      age: 25,
      goal: 'muscle',
      activityLevel: 'intermediate',
    );

    const testEntity = RegisterEntity(
      message: 'success',
      token: 'jwt_secure_token',
      user: UserEntity(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
      ),
    );

    setUp(() {
      fakeAuthRepo = FakeAuthRepo();
      registerUseCase = RegisterUseCase(fakeAuthRepo);
    });

    test(
      'calls AuthRepo.register with correct request and returns Success',
      () async {
        fakeAuthRepo.resultToReturn = const Success(testEntity);

        final result = await registerUseCase(testParams);

        expect(fakeAuthRepo.passedRequest, testParams);
        expect(result, isA<Success<RegisterEntity>>());
        final success = result as Success<RegisterEntity>;
        expect(success.data, testEntity);
      },
    );

    test('returns FailureResponse when AuthRepo.register fails', () async {
      fakeAuthRepo.resultToReturn = const FailureResponse(
        ServerMessageFailure('Email already exists'),
      );

      final result = await registerUseCase(testParams);

      expect(result, isA<FailureResponse<RegisterEntity>>());
      final failure = result as FailureResponse<RegisterEntity>;
      expect(failure.failure, isA<ServerMessageFailure>());
    });
  });
}
