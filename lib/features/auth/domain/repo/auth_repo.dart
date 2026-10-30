import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/auth/domain/entities/register_entity.dart';
import 'package:super_fitness/features/auth/domain/entities/register_params.dart';
import 'package:super_fitness/features/auth/domain/entities/social_auth_user_entity.dart';

abstract interface class AuthRepo {
  Future<ApiResults<RegisterEntity>> register(RegisterParams request);
  Future<ApiResults<SocialAuthUserEntity>> signInWithGoogle();
}
