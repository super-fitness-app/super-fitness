import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/auth/api/client/auth_api_client.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/auth_remote_data_source.dart';
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

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);

  @override
  Future<RegisterResponseModel> register(RegisterDto request) {
    return _authApiClient.register(request);
  }

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    return await _authApiClient.login(request);
  }

  @override
  Future<ForgetPasswordResponseDto> forgotPassword({required String email}) {
    final request = ForgetPasswordRequestDto(email: email);

    return _authApiClient.forgotPassword(request);
  }

  @override
  Future<VerifyOtpResponseDto> verifyOtp({
    required String email,
    required String otp,
  }) {
    final request = VerifyOtpRequestDto(email: email, otp: otp);

    return _authApiClient.verifyOtp(request);
  }

  @override
  Future<ResetPasswordResponseDto> resetPassword({
    required String otpToken,
    required String password,
    required String confirmPassword,
  }) {
    final request = ResetPasswordRequestDto(
      otpToken: otpToken,
      password: password,
      confirmPassword: confirmPassword,
    );

    return _authApiClient.resetPassword(request);
  }
}
