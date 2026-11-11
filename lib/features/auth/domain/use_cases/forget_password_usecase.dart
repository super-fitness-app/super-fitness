import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';

@injectable
class ForgetPasswordUseCase {
  final AuthRepo _repository;

  ForgetPasswordUseCase(this._repository);

  Future<ApiResults<void>> execute({required String email}) {
    return _repository.forgotPassword(email: email);
  }
}
