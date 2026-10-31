import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/safe_call.dart';
import 'package:super_fitness/core/const/app_strings.dart';
import 'package:super_fitness/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/social_auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
import 'package:super_fitness/features/auth/data/mapper/auth_mapper.dart';
import 'package:super_fitness/features/auth/data/models/request/login_request.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  // ignore: unused_field
  final AuthRemoteDataSource _authRemoteDataSource;
  // ignore: unused_field
  final AuthLocalDataSource _authLocalDataSource;
  final SocialAuthRemoteDataSource _socialAuthRemoteDataSource;

  AuthRepoImpl(
    this._authRemoteDataSource,
    this._authLocalDataSource,
    this._socialAuthRemoteDataSource,
  );

  @override
  Future<ApiResults<RegisterEntity>> register(RegisterParams request) {
    return safeCall<RegisterEntity>(() async {
      final dto = RegisterDto.fromDomain(request);
      final response = await _authRemoteDataSource.register(dto);
      await _authLocalDataSource.saveToken(response.token);
      return Success(response.toEntity());
    });
  }

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() {
    return safeCall<SocialAuthUserEntity>(() async {
      final response = await _socialAuthRemoteDataSource.signInWithGoogle();

      if (response == null) {
        return const Failure(CancelledFailure(AppStrings.signInCancelled));
      }
      return Success(response.toEntity());
    });
  }

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
