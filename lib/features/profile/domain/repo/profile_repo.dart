import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/profile/domain/entities/logout_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/change_password_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/edit_profile_entity.dart';
import 'package:super_fitness/features/profile/domain/params/change_password_params.dart';
import 'package:super_fitness/features/profile/domain/params/edit_profile_params.dart';

abstract interface class ProfileRepo {
  Future<ApiResults<LogoutEntity>> logout();

  Future<ApiResults<ChangePasswordEntity>> changePassword(
    ChangePasswordParams params,
  );

  Future<ApiResults<EditProfileEntity>> editProfile(EditProfileParams params);
}
