import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/profile/api/client/profile_api_client.dart';
import 'package:super_fitness/features/profile/data/data_source/remote/profile_remote_data_source.dart';
import 'package:super_fitness/features/profile/data/models/logout_response.dart';
import 'package:super_fitness/features/profile/data/models/change_password_response.dart';
import 'package:super_fitness/features/profile/data/models/edit_profile_response.dart';
import 'package:super_fitness/features/profile/data/request/change_password_request.dart';
import 'package:super_fitness/features/profile/data/request/edit_profile_request.dart';

@LazySingleton(as: ProfileRemoteDataSource)
class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  final ProfileApiClient _apiClient;

  ProfileRemoteDataSourceImpl(this._apiClient);

  @override
  Future<LogoutResponse> logout() async {
    return await _apiClient.logout();
  }

  @override
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request) async {
    return await _apiClient.changePassword(request);
  }

  @override
  Future<EditProfileResponse> editProfile(EditProfileRequest request) async {
    return await _apiClient.editProfile(request);
  }
}
