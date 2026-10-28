import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';

class LoginEntity {
  final String message;
  final UserEntity user;
  final String token;

  const LoginEntity({
    required this.message,
    required this.user,
    required this.token,
  });
}
