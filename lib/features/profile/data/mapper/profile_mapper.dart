
import 'package:super_fitness/features/auth/data/mapper/auth_mapper.dart';
import 'package:super_fitness/features/profile/data/models/logout_response.dart';
import 'package:super_fitness/features/profile/data/models/change_password_response.dart';
import 'package:super_fitness/features/profile/data/models/edit_profile_response.dart';
import 'package:super_fitness/features/profile/domain/entities/logout_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/change_password_entity.dart';
import 'package:super_fitness/features/profile/domain/entities/edit_profile_entity.dart';

abstract final class ProfileMapper {
  static LogoutEntity toLogoutEntity(LogoutResponse response) {
    return LogoutEntity(message: response.message);
  }

  static ChangePasswordEntity toChangePasswordEntity(
    ChangePasswordResponse response,
  ) {
    return ChangePasswordEntity(
      message: response.message,
      token: response.token,
    );
  }

  static EditProfileEntity toEditProfileEntity(
    EditProfileResponse response,
  ) {
    return EditProfileEntity(
      message: response.message,
      user: AuthMapper.loginUserToEntity(response.user),
    );
  }
}
