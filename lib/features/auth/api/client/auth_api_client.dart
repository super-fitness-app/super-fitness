// ignore_for_file: unused_field
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:super_fitness/core/const/endpoints.dart';
import 'package:super_fitness/features/auth/data/models/forget_password_request_dto.dart';
import 'package:super_fitness/features/auth/data/models/forget_password_response_dto.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/data/models/register_response_model.dart';
import 'package:super_fitness/features/auth/data/models/login_response.dart';
import 'package:super_fitness/features/auth/data/models/request/login_request.dart';
import 'package:super_fitness/features/auth/data/models/reset_password_request_dto.dart';
import 'package:super_fitness/features/auth/data/models/reset_password_response_dto.dart';
import 'package:super_fitness/features/auth/data/models/verify_otp_request_dto.dart';
import 'package:super_fitness/features/auth/data/models/verify_otp_response_dto.dart';

part 'auth_api_client.g.dart';

@singleton
@RestApi()
abstract class AuthApiClient {
  @factoryMethod
  factory AuthApiClient(Dio dio) = _AuthApiClient;

  @POST(Endpoints.register)
  Future<RegisterResponseModel> register(@Body() RegisterDto request);

  @POST(Endpoints.loginEndPoint)
  Future<LoginResponse> login(@Body() LoginRequest request);
  @POST(Endpoints.forgetPassword)
  Future<ForgetPasswordResponseDto> forgotPassword(
    @Body() ForgetPasswordRequestDto request,
  );

  @POST(Endpoints.verifyOtp)
  Future<VerifyOtpResponseDto> verifyOtp(@Body() VerifyOtpRequestDto request);

  @POST(Endpoints.resetPassword)
  Future<ResetPasswordResponseDto> resetPassword(
    @Body() ResetPasswordRequestDto request,
  );
}
