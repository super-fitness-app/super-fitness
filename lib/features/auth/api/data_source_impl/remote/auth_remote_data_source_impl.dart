import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/auth/api/client/auth_api_client.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/auth_remote_data_source.dart';

@Injectable(as: AuthRemoteDataSource)
class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final AuthApiClient _authApiClient;

  AuthRemoteDataSourceImpl(this._authApiClient);
}
