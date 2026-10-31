import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';
import 'package:super_fitness/features/auth/domain/use_cases/login_use_case.dart';

class _FakeAuthRepo implements AuthRepo {
  ApiResults<LoginEntity>? resultToReturn;
  LoginParams? lastParams;

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params) async {
    lastParams = params;
    return resultToReturn!;
  }
}

void main() {
  group('LoginUseCase', () {
    late _FakeAuthRepo fakeAuthRepo;
    late LoginUseCase useCase;

    final testUser = UserEntity(
      id: '123',
      firstName: 'John',
      lastName: 'Doe',
      email: 'john@example.com',
      gender: 'male',
      age: 25,
      weight: 75.0,
      height: 180.0,
      activityLevel: 'high',
      goal: 'fitness',
      photo: 'avatar.png',
      createdAt: DateTime(2025, 1, 1),
    );

    final testLoginEntity = LoginEntity(
      message: 'success',
      user: testUser,
      token: 'jwt_test_token',
    );

    setUp(() {
      fakeAuthRepo = _FakeAuthRepo();
      useCase = LoginUseCase(fakeAuthRepo);
    });

    test('delegates login call to AuthRepo with given params', () async {
      fakeAuthRepo.resultToReturn = Success<LoginEntity>(testLoginEntity);

      const params = LoginParams(
        email: 'john@example.com',
        password: 'Password1',
      );

      final result = await useCase(params);

      expect(fakeAuthRepo.lastParams, params);
      expect(result, isA<Success<LoginEntity>>());
      final data = (result as Success<LoginEntity>).data;
      expect(data, testLoginEntity);
    });

    test('returns failure response when AuthRepo fails', () async {
      fakeAuthRepo.resultToReturn = const FailureResponse<LoginEntity>(
        NetworkFailure(AppError.noConnection),
      );

      const params = LoginParams(
        email: 'john@example.com',
        password: 'Password1',
      );

      final result = await useCase(params);

      expect(result, isA<FailureResponse<LoginEntity>>());
      final failure = (result as FailureResponse<LoginEntity>).failure;
      expect(failure, const NetworkFailure(AppError.noConnection));
    });
  });
}
