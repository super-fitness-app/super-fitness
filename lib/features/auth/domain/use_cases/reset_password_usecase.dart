import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';

@injectable
class ResetPasswordUseCase {
  final AuthRepo _repository;

  ResetPasswordUseCase(this._repository);

  Future<ApiResults<void>> execute({
    required String otpToken,
    required String password,
    required String confirmPassword,
  }) {
    return _repository.resetPassword(
      otpToken: otpToken,
      password: password,
      confirmPassword: confirmPassword,
    );
  }
}
