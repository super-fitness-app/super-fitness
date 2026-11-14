import 'package:dio/dio.dart' hide Headers;
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:super_fitness/core/const/app_constants.dart';
import 'package:super_fitness/core/const/endpoints.dart';
import 'package:super_fitness/features/profile/data/models/change_password_response.dart';
import 'package:super_fitness/features/profile/data/models/edit_profile_response.dart';
import 'package:super_fitness/features/profile/data/models/logout_response.dart';
import 'package:super_fitness/features/profile/data/request/change_password_request.dart';
import 'package:super_fitness/features/profile/data/request/edit_profile_request.dart';

part 'profile_api_client.g.dart';

@singleton
@RestApi(baseUrl: Endpoints.baseUrl)
abstract class ProfileApiClient {
  @factoryMethod
  factory ProfileApiClient(Dio dio) = _ProfileApiClient;

  @GET(Endpoints.logout)
  @Headers(<String, dynamic>{'Authorization': ''})
  Future<LogoutResponse> logout();

  @PATCH(Endpoints.changePassword)
  @Headers(<String, dynamic>{'Authorization': ''})
  Future<ChangePasswordResponse> changePassword(
    @Body() ChangePasswordRequest request,
  );

  @PUT(Endpoints.editProfile)
  @Headers(<String, dynamic>{'Authorization': ''})
  Future<EditProfileResponse> editProfile(@Body() EditProfileRequest request);
}
