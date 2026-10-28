import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/mapper/auth_mapper.dart';
import 'package:super_fitness/features/auth/data/request/login_request.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  final AuthRemoteDataSource _authRemoteDataSource;
  final AuthLocalDataSource _authLocalDataSource;
  // final SessionService _sessionService;

  AuthRepoImpl(
    this._authRemoteDataSource,
    this._authLocalDataSource,
    // this._sessionService,
  );

  // @override
  // Future<ApiResults<LoginEntity>> login(LoginParams params) async {
  //   try {
  //     final request = LoginRequest(
  //       email: params.email,
  //       password: params.password,
  //     );

  //     final response = await _authRemoteDataSource.login(request);

  //     final loginEntity = AuthMapper.toLoginEntity(response);
  //     await _sessionService.saveUser(loginEntity.user);

  //     return Success<LoginEntity>(loginEntity);
  //   } on Exception catch (exception) {
  //     return Failure<LoginEntity>(exception);
  //   }
  // }
}
