import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/change_password_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/edit_profile_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/logout_entity.dart';
import 'package:super_fitness/features/profile/domain/params/change_password_params.dart';
import 'package:super_fitness/features/profile/domain/params/edit_profile_params.dart';
import 'package:super_fitness/features/profile/domain/repo/profile_repo.dart';
import 'package:super_fitness/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:super_fitness/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:super_fitness/features/profile/domain/use_cases/logout_use_case.dart';

class FakeProfileRepo extends Fake implements ProfileRepo {
  ApiResults<LogoutEntity> logoutResult = const Success(
    LogoutEntity(message: 'Logged out'),
  );
  ApiResults<ChangePasswordEntity> changePasswordResult = const Success(
    ChangePasswordEntity(message: 'Password changed', token: 'new_token'),
  );
  ApiResults<EditProfileEntity> editProfileResult = const Success(
    EditProfileEntity(
      message: 'Profile updated',
      user: UserEntity(firstName: 'John', lastName: 'Doe'),
    ),
  );

  ChangePasswordParams? lastChangePasswordParams;
  EditProfileParams? lastEditProfileParams;

  @override
  Future<ApiResults<LogoutEntity>> logout() async => logoutResult;

  @override
  Future<ApiResults<ChangePasswordEntity>> changePassword(
    ChangePasswordParams params,
  ) async {
    lastChangePasswordParams = params;
    return changePasswordResult;
  }

  @override
  Future<ApiResults<EditProfileEntity>> editProfile(
    EditProfileParams params,
  ) async {
    lastEditProfileParams = params;
    return editProfileResult;
  }
}

void main() {
  group('Profile Use Cases Tests', () {
    late FakeProfileRepo repo;
    late LogoutUseCase logoutUseCase;
    late ChangePasswordUseCase changePasswordUseCase;
    late EditProfileUseCase editProfileUseCase;

    setUp(() {
      repo = FakeProfileRepo();
      logoutUseCase = LogoutUseCase(repo);
      changePasswordUseCase = ChangePasswordUseCase(repo);
      editProfileUseCase = EditProfileUseCase(repo);
    });

    test('LogoutUseCase calls repo.logout and returns result', () async {
      final result = await logoutUseCase();

      expect(result, isA<Success<LogoutEntity>>());
      final entity = (result as Success<LogoutEntity>).data;
      expect(entity.message, equals('Logged out'));
    });

    test('LogoutUseCase returns failure on repository error', () async {
      repo.logoutResult = const FailureResponse(
        ServerMessageFailure('Network error'),
      );

      final result = await logoutUseCase();

      expect(result, isA<FailureResponse<LogoutEntity>>());
    });

    test(
      'ChangePasswordUseCase forwards params to repo and returns result',
      () async {
        const params = ChangePasswordParams(
          password: 'oldPassword123',
          newPassword: 'newPassword123',
        );

        final result = await changePasswordUseCase(params);

        expect(repo.lastChangePasswordParams, equals(params));
        expect(result, isA<Success<ChangePasswordEntity>>());
        final entity = (result as Success<ChangePasswordEntity>).data;
        expect(entity.token, equals('new_token'));
      },
    );

    test(
      'EditProfileUseCase forwards params to repo and returns result',
      () async {
        const params = EditProfileParams(
          firstName: 'John',
          lastName: 'Doe',
          weight: 75.0,
        );

        final result = await editProfileUseCase(params);

        expect(repo.lastEditProfileParams, equals(params));
        expect(result, isA<Success<EditProfileEntity>>());
        final entity = (result as Success<EditProfileEntity>).data;
        expect(entity.message, equals('Profile updated'));
      },
    );
  });
}
