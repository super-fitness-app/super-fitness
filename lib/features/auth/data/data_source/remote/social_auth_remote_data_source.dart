import 'package:super_fitness/features/auth/data/models/social_auth_user_model.dart';

abstract class SocialAuthRemoteDataSource {
  Future<SocialAuthUserModel?> signInWithGoogle();
  Future<SocialAuthUserModel?> signInWithFacebook();
  Future<void> signOut();
}
