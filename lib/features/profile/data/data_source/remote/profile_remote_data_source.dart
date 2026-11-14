
import 'package:super_fitness/features/profile/data/models/logout_response.dart';
import 'package:super_fitness/features/profile/data/models/change_password_response.dart';
import 'package:super_fitness/features/profile/data/models/edit_profile_response.dart';
import 'package:super_fitness/features/profile/data/request/change_password_request.dart';
import 'package:super_fitness/features/profile/data/request/edit_profile_request.dart';

abstract interface class ProfileRemoteDataSource {
  Future<LogoutResponse> logout();

  Future<ChangePasswordResponse> changePassword(
    ChangePasswordRequest request,
  );

  Future<EditProfileResponse> editProfile(
    EditProfileRequest request,
  );
}
