import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/data/models/register_dto.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';

@injectable
class RegisterUseCase {
  final AuthRepo _authRepo;
  const RegisterUseCase(this._authRepo);

  Future<ApiResults<RegisterEntity>> call(RegisterDto request) {
    return _authRepo.register(request);
  }
}
