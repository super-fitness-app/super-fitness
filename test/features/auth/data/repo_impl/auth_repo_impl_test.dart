import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/models/login_response.dart';
import 'package:super_fitness/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:super_fitness/features/auth/data/request/login_request.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';

class _FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  LoginResponse? responseToReturn;
  Exception? exceptionToThrow;
  LoginRequest? lastRequest;

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    lastRequest = request;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return responseToReturn!;
  }
}

class _FakeAuthLocalDataSource implements AuthLocalDataSource {}

void main() {
  group('AuthRepoImpl.login', () {
    late _FakeAuthRemoteDataSource fakeRemoteDataSource;
    late _FakeAuthLocalDataSource fakeLocalDataSource;
    late AuthRepoImpl repo;

    final testUser = LoginUser(
      id: 'u1',
      firstName: 'Jane',
      lastName: 'Smith',
      email: 'jane@example.com',
      gender: 'female',
      age: 28,
      weight: 60.0,
      height: 165.0,
      activityLevel: 'moderate',
      goal: 'tone',
      photo: 'pic.jpg',
      createdAt: DateTime(2025, 1, 1),
    );

    setUp(() {
      fakeRemoteDataSource = _FakeAuthRemoteDataSource();
      fakeLocalDataSource = _FakeAuthLocalDataSource();
      repo = AuthRepoImpl(fakeRemoteDataSource, fakeLocalDataSource);
    });

    test('returns Success<LoginEntity> on successful remote call', () async {
      fakeRemoteDataSource.responseToReturn = LoginResponse(
        message: 'login success',
        user: testUser,
        token: 'token123',
      );

      const params = LoginParams(
        email: 'jane@example.com',
        password: 'Password1',
      );

      final result = await repo.login(params);

      expect(result, isA<Success<LoginEntity>>());
      final data = (result as Success<LoginEntity>).data;
      expect(data.token, 'token123');
      expect(data.user.email, 'jane@example.com');
      expect(fakeRemoteDataSource.lastRequest?.email, 'jane@example.com');
    });

    test('returns FailureResponse on network exception', () async {
      fakeRemoteDataSource.exceptionToThrow = Exception('Network fail');

      const params = LoginParams(
        email: 'jane@example.com',
        password: 'Password1',
      );

      final result = await repo.login(params);

      expect(result, isA<FailureResponse<LoginEntity>>());
    });
  });
}
