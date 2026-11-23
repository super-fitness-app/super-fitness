import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:super_fitness/features/auth/data/models/login_response.dart';
import 'package:super_fitness/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:super_fitness/features/profile/data/models/change_password_response.dart';
import 'package:super_fitness/features/profile/data/models/edit_profile_response.dart';
import 'package:super_fitness/features/profile/data/models/logout_response.dart';
import 'package:super_fitness/features/profile/data/repo_impl/profile_repo_impl.dart';
import 'package:super_fitness/features/profile/data/request/change_password_request.dart';
import 'package:super_fitness/features/profile/data/request/edit_profile_request.dart';
import 'package:super_fitness/features/profile/domain/entities/change_password_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/edit_profile_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/logout_entity.dart';
import 'package:super_fitness/features/profile/domain/params/change_password_params.dart';
import 'package:super_fitness/features/profile/domain/params/edit_profile_params.dart';

class FakeProfileRemoteDataSource extends Fake
    implements ProfileRemoteDataSource {
  LogoutResponse logoutResponse = const LogoutResponse(message: 'success');
  ChangePasswordResponse changePasswordResponse =
      const ChangePasswordResponse(message: 'success', token: 'jwt_token');
  EditProfileResponse editProfileResponse = EditProfileResponse(
    message: 'success',
    user: LoginUser(
      id: '1',
      firstName: 'Jane',
      lastName: 'Smith',
      email: 'jane@example.com',
      gender: 'female',
      age: 28,
      weight: 65.0,
      height: 170.0,
      activityLevel: 'level2',
      goal: 'getFitter',
      photo: 'photo_url',
      createdAt: DateTime(2026, 1, 1),
    ),
  );

  ChangePasswordRequest? lastChangePasswordRequest;
  EditProfileRequest? lastEditProfileRequest;

  @override
  Future<LogoutResponse> logout() async => logoutResponse;

  @override
  Future<ChangePasswordResponse> changePassword(
    ChangePasswordRequest request,
  ) async {
    lastChangePasswordRequest = request;
    return changePasswordResponse;
  }

  @override
  Future<EditProfileResponse> editProfile(EditProfileRequest request) async {
    lastEditProfileRequest = request;
    return editProfileResponse;
  }
}

class FakeAuthLocalDataSource extends Fake implements AuthLocalDataSource {
  String? savedToken;

  @override
  Future<String> getToken() async => savedToken ?? '';

  @override
  Future<void> saveToken(String? token) async {
    savedToken = token;
  }

  @override
  Future<void> deleteToken() async {
    savedToken = null;
  }

  @override
  Future<void> clear() async {
    savedToken = null;
  }
}

void main() {
  group('ProfileRepoImpl Tests', () {
    late FakeProfileRemoteDataSource remoteDataSource;
    late FakeAuthLocalDataSource localDataSource;
    late ProfileRepoImpl repo;

    setUp(() {
      remoteDataSource = FakeProfileRemoteDataSource();
      localDataSource = FakeAuthLocalDataSource();
      repo = ProfileRepoImpl(remoteDataSource, localDataSource);
    });

    test('logout calls remote data source and returns LogoutEntity', () async {
      final result = await repo.logout();

      expect(result, isA<Success<LogoutEntity>>());
      final entity = (result as Success<LogoutEntity>).data;
      expect(entity.message, equals('success'));
    });

    test('changePassword calls remote data source, saves token, and returns entity', () async {
      const params = ChangePasswordParams(
        password: 'currentPassword123',
        newPassword: 'newPassword123',
      );

      final result = await repo.changePassword(params);

      expect(remoteDataSource.lastChangePasswordRequest?.password, equals('currentPassword123'));
      expect(remoteDataSource.lastChangePasswordRequest?.newPassword, equals('newPassword123'));
      expect(localDataSource.savedToken, equals('jwt_token'));
      expect(result, isA<Success<ChangePasswordEntity>>());
    });

    test('editProfile calls remote data source and returns EditProfileEntity', () async {
      const params = EditProfileParams(
        firstName: 'Jane',
        lastName: 'Smith',
        email: 'jane@example.com',
      );

      final result = await repo.editProfile(params);

      expect(remoteDataSource.lastEditProfileRequest?.firstName, equals('Jane'));
      expect(remoteDataSource.lastEditProfileRequest?.email, equals('jane@example.com'));
      expect(result, isA<Success<EditProfileEntity>>());
    });
  });
}
