import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/auth/api/client/auth_api_client.dart';
import 'package:super_fitness/features/auth/api/data_source_impl/remote/auth_remote_data_source_impl.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/data/models/register_response_model.dart';

class FakeAuthApiClient implements AuthApiClient {
  RegisterResponseModel? responseToReturn;
  Exception? exceptionToThrow;
  RegisterDto? capturedRequest;

  @override
  Future<RegisterResponseModel> register(RegisterDto request) async {
    capturedRequest = request;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return responseToReturn!;
  }
}

void main() {
  group('AuthRemoteDataSourceImpl Tests', () {
    late FakeAuthApiClient fakeApiClient;
    late AuthRemoteDataSource remoteDataSource;

    const testDto = RegisterDto(
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
      token: 'jwt_test_token',
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
      fakeApiClient = FakeAuthApiClient();
      remoteDataSource = AuthRemoteDataSourceImpl(fakeApiClient);
    });

    test(
      'register forwards request to AuthApiClient and returns response',
      () async {
        fakeApiClient.responseToReturn = testResponse;

        final result = await remoteDataSource.register(testDto);

        expect(fakeApiClient.capturedRequest, testDto);
        expect(result.token, 'jwt_test_token');
        expect(result.message, 'success');
        expect(result.user.firstName, 'John');
      },
    );

    test('register propagates DioException when AuthApiClient fails', () async {
      fakeApiClient.exceptionToThrow = DioException(
        requestOptions: RequestOptions(path: '/auth/signup'),
        type: DioExceptionType.connectionTimeout,
      );

      expect(
        () => remoteDataSource.register(testDto),
        throwsA(isA<DioException>()),
      );
    });
  });
}
