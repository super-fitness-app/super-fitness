import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';

@injectable
class VerifyOtpUseCase {
  final AuthRepo _repository;

  VerifyOtpUseCase(this._repository);

  Future<ApiResults<Map<String, dynamic>>> execute({
    required String email,
    required String otp,
  }) {
    return _repository.verifyOtp(email: email, otp: otp);
  }
}
