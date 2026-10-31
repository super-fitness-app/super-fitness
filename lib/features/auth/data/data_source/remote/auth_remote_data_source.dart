import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/data/models/register_response_model.dart';

import 'package:super_fitness/features/auth/data/models/login_response.dart';
import 'package:super_fitness/features/auth/data/models/request/login_request.dart';

abstract interface class AuthRemoteDataSource {
  Future<RegisterResponseModel> register(RegisterDto request);

  Future<LoginResponse> login(LoginRequest request);
}
