import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/data/models/register_response_model.dart';

abstract interface class AuthRemoteDataSource {
  Future<RegisterResponseModel> register(RegisterDto request);
}
