import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/domain/entities/login_entity.dart';
import 'package:super_fitness/features/auth/domain/params/login_params.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';

@injectable
class LoginUseCase {
  final AuthRepo _authRepo;

  const LoginUseCase(this._authRepo);

  Future<ApiResults<LoginEntity>> call(LoginParams params) {
    return _authRepo.login(params);
  }
}
