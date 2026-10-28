import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/config/network/safe_call.dart';
import 'package:super_fitness/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/social_auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
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
  Future<ApiResults<RegisterEntity>> register(RegisterDto request) {
    return safeCall<RegisterEntity>(() async {
      final response = await _authRemoteDataSource.register(request);
      await _authLocalDataSource.saveToken(response.token);
      return Success(response.toEntity());
    });
  }

  @override
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle() {
    return safeCall<SocialAuthUserEntity>(() async {
      final response = await _socialAuthRemoteDataSource.signInWithGoogle();

      if (response == null) {
        return const Failure(NetworkFailure(AppError.cancelled));
      }
      return Success(response.toEntity());
    });
  }
}
