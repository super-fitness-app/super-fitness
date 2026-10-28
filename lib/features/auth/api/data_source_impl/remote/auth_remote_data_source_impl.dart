import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/auth/api/client/auth_api_client.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/data/models/register_response_model.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  // ignore: unused_field
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);

  @override
  Future<RegisterResponseModel> register(RegisterDto request) {
    return _authApiClient.register(request);
  }
}
