import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/data/models/register_response_model.dart';
import 'package:super_fitness/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
  RegisterResponseModel? responseToReturn;
  Exception? exceptionToThrow;

  @override
  Future<RegisterResponseModel> register(RegisterDto request) async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return responseToReturn!;
  }
}

class FakeAuthLocalDataSource implements AuthLocalDataSource {
  String? savedToken;

  @override
  Future<void> saveToken(String token) async {
    savedToken = token;
  }

  @override
  Future<String> getToken() async => savedToken ?? '';

  @override
  Future<void> clear() async {
    savedToken = null;
  }
}

void main() {
  group('AuthRepoImpl Tests', () {
    late FakeAuthRemoteDataSource fakeRemoteDataSource;
    late FakeAuthLocalDataSource fakeLocalDataSource;
    late AuthRepoImpl authRepo;

    final testDto = RegisterDto(
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

    final testResponse = RegisterResponseModel(
      message: 'success',
      token: 'jwt_secure_token',
      user: UserModel(
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@example.com',
        gender: 'male',
        age: 25,
        weight: 75,
        height: 180,
        activityLevel: 'intermediate',
        goal: 'muscle',
        photo: 'avatar.png',
        id: '12345',
        createdAt: DateTime(2025, 1, 1),
      ),
    );

    setUp(() {
      fakeRemoteDataSource = FakeAuthRemoteDataSource();
      fakeLocalDataSource = FakeAuthLocalDataSource();
      authRepo = AuthRepoImpl(fakeRemoteDataSource, fakeLocalDataSource);
    });

    test(
      'register saves token locally and returns Success on valid remote response',
      () async {
        fakeRemoteDataSource.responseToReturn = testResponse;

        final result = await authRepo.register(testDto);

        expect(result, isA<Success<RegisterEntity>>());
        final success = result as Success<RegisterEntity>;
        expect(success.data.token, 'jwt_secure_token');
        expect(fakeLocalDataSource.savedToken, 'jwt_secure_token');
      },
    );

    test(
      'register returns FailureResponse and does not save token on DioException',
      () async {
        fakeRemoteDataSource.exceptionToThrow = DioException(
          requestOptions: RequestOptions(path: '/auth/signup'),
          type: DioExceptionType.connectionTimeout,
        );

        final result = await authRepo.register(testDto);

        expect(result, isA<FailureResponse<RegisterEntity>>());
        expect(fakeLocalDataSource.savedToken, isNull);
      },
    );
  });
}
