import 'dart:convert';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_cubit.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_event.dart';
import 'package:super_fitness/features/main_layout/profile/presentation/cubit/profile_state.dart';
import 'package:super_fitness/features/profile/domain/entities/change_password_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/edit_profile_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/logout_entity.dart';
import 'package:super_fitness/features/profile/domain/params/change_password_params.dart';
import 'package:super_fitness/features/profile/domain/params/edit_profile_params.dart';
import 'package:super_fitness/features/profile/domain/repo/profile_repo.dart';
import 'package:super_fitness/features/profile/domain/use_cases/change_password_use_case.dart';
import 'package:super_fitness/features/profile/domain/use_cases/edit_profile_use_case.dart';
import 'package:super_fitness/features/profile/domain/use_cases/logout_use_case.dart';

class FakeSessionService extends Fake implements SessionService {
  String? userDataJson;
  String token = 'test_token';
  bool sessionCleared = false;

  @override
  Future<String> getUserData() async {
    if (userDataJson == null) throw Exception('No user data');
    return userDataJson!;
  }

  @override
  Future<String> getToken() async => token;

  @override
  Future<void> saveToken(String newToken) async {
    token = newToken;
  }

  @override
  Future<void> saveUserData(String data) async {
    userDataJson = data;
  }

  @override
  Future<void> clearSession() async {
    sessionCleared = true;
    token = '';
    userDataJson = null;
  }
}

class FakeProfileRepoForCubit extends Fake implements ProfileRepo {
  ApiResults<LogoutEntity> logoutResult =
      const Success(LogoutEntity(message: 'Logged out'));
  ApiResults<ChangePasswordEntity> changePasswordResult =
      const Success(ChangePasswordEntity(message: 'Password changed', token: 'token'));
  ApiResults<EditProfileEntity> editProfileResult = const Success(
    EditProfileEntity(
      message: 'Updated',
      user: UserEntity(firstName: 'John', lastName: 'Doe'),
    ),
  );

  @override
  Future<ApiResults<LogoutEntity>> logout() async => logoutResult;

  @override
  Future<ApiResults<ChangePasswordEntity>> changePassword(
    ChangePasswordParams params,
  ) async => changePasswordResult;

  @override
  Future<ApiResults<EditProfileEntity>> editProfile(
    EditProfileParams params,
  ) async => editProfileResult;
}

void main() {
  group('ProfileCubit Unit Tests', () {
    late FakeProfileRepoForCubit repo;
    late FakeSessionService sessionService;
    late EditProfileUseCase editProfileUseCase;
    late ChangePasswordUseCase changePasswordUseCase;
    late LogoutUseCase logoutUseCase;
    late ProfileCubit cubit;

    setUp(() {
      repo = FakeProfileRepoForCubit();
      sessionService = FakeSessionService();
      editProfileUseCase = EditProfileUseCase(repo);
      changePasswordUseCase = ChangePasswordUseCase(repo);
      logoutUseCase = LogoutUseCase(repo);
      cubit = ProfileCubit(
        editProfileUseCase,
        changePasswordUseCase,
        logoutUseCase,
        sessionService,
      );
    });

    tearDown(() async {
      await cubit.close();
    });

    test('initial state is default ProfileState', () {
      expect(cubit.state, equals(const ProfileState()));
      expect(cubit.state.isCurrentPasswordVisible, isFalse);
      expect(cubit.state.isNewPasswordVisible, isFalse);
      expect(cubit.state.isConfirmPasswordVisible, isFalse);
    });

    blocTest<ProfileCubit, ProfileState>(
      'GetUserDataEvent loads user from sessionService successfully',
      build: () {
        sessionService.userDataJson = jsonEncode({
          '_id': '123',
          'firstName': 'John',
          'lastName': 'Doe',
          'email': 'john@example.com',
          'gender': 'male',
          'age': 25,
          'weight': 80.0,
          'height': 180.0,
          'activityLevel': 'level3',
          'goal': 'getFitter',
          'photo': 'https://example.com/photo.png',
          'createdAt': '2026-01-01T00:00:00.000Z',
        });
        return cubit;
      },
      act: (cubit) => cubit.doEvent(const GetUserDataEvent()),
      expect: () => [
        isA<ProfileState>().having((s) => s.user?.firstName, 'firstName', 'John'),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'Toggle password visibility events toggle their respective flags',
      build: () => cubit,
      act: (cubit) {
        cubit.doEvent(const ToggleCurrentPasswordVisibilityEvent());
        cubit.doEvent(const ToggleNewPasswordVisibilityEvent());
        cubit.doEvent(const ToggleConfirmPasswordVisibilityEvent());
      },
      expect: () => [
        isA<ProfileState>().having((s) => s.isCurrentPasswordVisible, 'current', isTrue),
        isA<ProfileState>().having((s) => s.isNewPasswordVisible, 'new', isTrue),
        isA<ProfileState>().having((s) => s.isConfirmPasswordVisible, 'confirm', isTrue),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'SubmitChangePasswordEvent emits failure when passwords do not match',
      build: () => cubit,
      act: (cubit) => cubit.doEvent(const SubmitChangePasswordEvent(
        password: 'currentPassword123',
        newPassword: 'newPassword123',
        confirmPassword: 'differentPassword123',
      )),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.changePasswordApiState.isFailure,
          'isFailure',
          isTrue,
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'SubmitChangePasswordEvent emits loading and success when passwords match',
      build: () => cubit,
      act: (cubit) => cubit.doEvent(const SubmitChangePasswordEvent(
        password: 'currentPassword123',
        newPassword: 'newPassword123',
        confirmPassword: 'newPassword123',
      )),
      expect: () => [
        isA<ProfileState>().having(
          (s) => s.changePasswordApiState.isLoading,
          'isLoading',
          isTrue,
        ),
        isA<ProfileState>().having(
          (s) => s.changePasswordApiState.isSuccess,
          'isSuccess',
          isTrue,
        ),
      ],
    );

    blocTest<ProfileCubit, ProfileState>(
      'LogoutEvent emits loading, clears session, and emits success',
      build: () => cubit,
      act: (cubit) => cubit.doEvent(const LogoutEvent()),
      expect: () => [
        isA<ProfileState>().having((s) => s.logoutApiState.isLoading, 'isLoading', isTrue),
        isA<ProfileState>().having((s) => s.logoutApiState.isSuccess, 'isSuccess', isTrue),
      ],
      verify: (_) {
        expect(sessionService.sessionCleared, isTrue);
      },
    );
  });
}
