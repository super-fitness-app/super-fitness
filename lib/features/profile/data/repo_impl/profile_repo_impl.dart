import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/safe_call.dart';
import 'package:super_fitness/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:super_fitness/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:super_fitness/features/profile/data/mapper/profile_mapper.dart';
import 'package:super_fitness/features/profile/data/request/change_password_request.dart';
import 'package:super_fitness/features/profile/data/request/edit_profile_request.dart';
import 'package:super_fitness/features/profile/domain/entities/logout_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/change_password_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/edit_profile_entity.dart';
import 'package:super_fitness/features/profile/domain/params/change_password_params.dart';
import 'package:super_fitness/features/profile/domain/params/edit_profile_params.dart';
import 'package:super_fitness/features/profile/domain/repo/profile_repo.dart';

@Injectable(as: ProfileRepo)
class ProfileRepoImpl implements ProfileRepo {
  final ProfileRemoteDataSource _profileRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;

  ProfileRepoImpl(this._profileRemoteDataSource, this._authLocalDataSource);

  @override
  Future<ApiResults<LogoutEntity>> logout() {
    return safeCall<LogoutEntity>(() async {
      final response = await _profileRemoteDataSource.logout();

      return Success(ProfileMapper.toLogoutEntity(response));
    });
  }

  @override
  Future<ApiResults<ChangePasswordEntity>> changePassword(
    ChangePasswordParams params,
  ) {
    return safeCall<ChangePasswordEntity>(() async {
      final request = ChangePasswordRequest(
        password: params.password,
        newPassword: params.newPassword,
      );

      final response = await _profileRemoteDataSource.changePassword(request);

      final entity = ProfileMapper.toChangePasswordEntity(response);

      await _authLocalDataSource.saveToken(entity.token);

      return Success(entity);
    });
  }

  @override
  Future<ApiResults<EditProfileEntity>> editProfile(EditProfileParams params) {
    return safeCall<EditProfileEntity>(() async {
      final request = EditProfileRequest(
        firstName: params.firstName,
        lastName: params.lastName,
        email: params.email,
        gender: params.gender,
        age: params.age,
        weight: params.weight,
        height: params.height,
        activityLevel: params.activityLevel,
        goal: params.goal,
        photo: params.photo,
      );

      final response = await _profileRemoteDataSource.editProfile(request);

      return Success(ProfileMapper.toEditProfileEntity(response));
    });
  }
}
