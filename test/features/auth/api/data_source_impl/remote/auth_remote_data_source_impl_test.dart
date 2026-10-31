import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/features/auth/api/client/auth_api_client.dart';
import 'package:super_fitness/features/auth/api/data_source_impl/remote/auth_remote_data_source_impl.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/models/login_response.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/data/models/register_response_model.dart';
import 'package:super_fitness/features/auth/data/models/request/login_request.dart';

class FakeAuthApiClient implements AuthApiClient {
  RegisterResponseModel? responseToReturn;
  LoginResponse? loginResponseToReturn;
  Exception? exceptionToThrow;
  RegisterDto? capturedRequest;
  LoginRequest? capturedLoginRequest;

  @override
  Future<RegisterResponseModel> register(RegisterDto request) async {
    capturedRequest = request;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return responseToReturn!;
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    capturedLoginRequest = request;
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return loginResponseToReturn!;
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

    test('login forwards request to AuthApiClient and returns response', () async {
      final loginResponse = LoginResponse(
        message: 'login success',
        token: 'token123',
        user: LoginUser(
          id: '1',
          firstName: 'John',
          lastName: 'Doe',
          email: 'john@example.com',
          gender: 'male',
          age: 25,
          weight: 75.0,
          height: 180.0,
          activityLevel: 'intermediate',
          goal: 'muscle',
          photo: 'avatar.png',
          createdAt: DateTime(2025, 1, 1),
        ),
      );
      fakeApiClient.loginResponseToReturn = loginResponse;

      const loginReq = LoginRequest(
        email: 'john@example.com',
        password: 'Password123!',
      );
      final result = await remoteDataSource.login(loginReq);

      expect(fakeApiClient.capturedLoginRequest, loginReq);
      expect(result.token, 'token123');
      expect(result.message, 'login success');
      expect(result.user.firstName, 'John');
    });
  });
}
