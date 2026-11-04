import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';
import 'package:super_fitness/features/auth/domain/repo/auth_repo.dart';

@injectable
class SignInWithGoogleUseCase {
  final AuthRepo _authRepo;
  const SignInWithGoogleUseCase(this._authRepo);

  Future<ApiResults<SocialAuthUserEntity>> call() {
    return _authRepo.signInWithGoogle();
  }
}
