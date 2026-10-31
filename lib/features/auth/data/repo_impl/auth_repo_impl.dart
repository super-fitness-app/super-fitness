import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/safe_call.dart';
import 'package:super_fitness/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/mapper/auth_mapper.dart';
import 'package:super_fitness/features/auth/data/request/login_request.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  // ignore: unused_field
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepoImpl(
    this._authRemoteDataSource,
    this._authLocalDataSource,
  );

  @override
  Future<ApiResults<LoginEntity>> login(LoginParams params) async {
    return safeCall(() async {
      final request = LoginRequest(
        email: params.email,
        password: params.password,
      );
      final response = await _authRemoteDataSource.login(request);
      final loginEntity = AuthMapper.toLoginEntity(response);
      return Success<LoginEntity>(loginEntity);
    });
  }
}
