import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/social_auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/data/models/register_response_model.dart';
import 'package:super_fitness/features/auth/data/models/social_auth_user_model.dart';
import 'package:super_fitness/features/auth/data/repo_impl/auth_repo_impl.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';

class FakeAuthRemoteDataSource implements AuthRemoteDataSource {
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

class FakeSocialAuthRemoteDataSource implements SocialAuthRemoteDataSource {
  SocialAuthUserModel? responseToReturn;
  Exception? exceptionToThrow;

  @override
  Future<SocialAuthUserModel?> signInWithGoogle() async {
    if (exceptionToThrow != null) {
      throw exceptionToThrow!;
    }
    return responseToReturn;
  }

  @override
  Future<SocialAuthUserModel?> signInWithFacebook() async {
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {}
}

void main() {
  group('AuthRepoImpl Tests', () {
    late FakeAuthRemoteDataSource fakeRemoteDataSource;
    late FakeAuthLocalDataSource fakeLocalDataSource;
    late FakeSocialAuthRemoteDataSource fakeSocialRemoteDataSource;
    late AuthRepoImpl authRepo;

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
      fakeSocialRemoteDataSource = FakeSocialAuthRemoteDataSource();
      authRepo = AuthRepoImpl(
        fakeRemoteDataSource,
        fakeLocalDataSource,
        fakeSocialRemoteDataSource,
      );
    });

    test('register saves token locally and returns Success on valid remote response',
        () async {
      fakeRemoteDataSource.responseToReturn = testResponse;

      final result = await authRepo.register(testParams);

      expect(result, isA<Success<RegisterEntity>>());
      final success = result as Success<RegisterEntity>;
      expect(success.data.token, 'jwt_secure_token');
      expect(fakeLocalDataSource.savedToken, 'jwt_secure_token');
      expect(
        fakeRemoteDataSource.capturedRequest,
        equals(RegisterDto.fromDomain(testParams)),
      );
    });

    test('register returns FailureResponse and does not save token on DioException',
        () async {
      fakeRemoteDataSource.exceptionToThrow = DioException(
        requestOptions: RequestOptions(path: '/auth/signup'),
        type: DioExceptionType.connectionTimeout,
      );

      final result = await authRepo.register(testParams);

      expect(result, isA<FailureResponse<RegisterEntity>>());
      expect(fakeLocalDataSource.savedToken, isNull);
    });

    test('signInWithGoogle returns Success when social auth remote returns user', () async {
      fakeSocialRemoteDataSource.responseToReturn = const SocialAuthUserModel(
        id: 'user_123',
        email: 'user@example.com',
        displayName: 'John Doe',
        photoUrl: 'https://example.com/photo.png',
      );

      final result = await authRepo.signInWithGoogle();

      expect(result, isA<Success<SocialAuthUserEntity>>());
      final success = result as Success<SocialAuthUserEntity>;
      expect(success.data.id, 'user_123');
      expect(success.data.email, 'user@example.com');
      expect(success.data.displayName, 'John Doe');
    });

    test('signInWithGoogle returns Failure with CancelledFailure when remote returns null', () async {
      fakeSocialRemoteDataSource.responseToReturn = null;

      final result = await authRepo.signInWithGoogle();

      expect(result, isA<FailureResponse<SocialAuthUserEntity>>());
      final failure = (result as FailureResponse<SocialAuthUserEntity>).failure;
      expect(failure, isA<CancelledFailure>());
      expect((failure as CancelledFailure).message, 'Sign-in cancelled');
    });

    test('signInWithGoogle returns FailureResponse when remote throws an exception', () async {
      fakeSocialRemoteDataSource.exceptionToThrow = Exception('Google sign-in failed');

      final result = await authRepo.signInWithGoogle();

      expect(result, isA<FailureResponse<SocialAuthUserEntity>>());
    });
  });
}
