import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/auth/data/data_source/local/auth_local_data_source.dart';
import 'package:super_fitness/features/auth/data/data_source/remote/auth_remote_data_source.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';

@Injectable(as: AuthRepo)
class AuthRepoImpl implements AuthRepo {
  // ignore: unused_field
  final AuthRemoteDataSource _authRemoteDataSource;
  // ignore: unused_field
  final AuthLocalDataSource _authLocalDataSource;

  AuthRepoImpl(this._authRemoteDataSource, this._authLocalDataSource);
}
