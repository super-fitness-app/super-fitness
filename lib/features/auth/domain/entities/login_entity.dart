import 'package:equatable/equatable.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';

class LoginEntity extends Equatable {
  final String message;
  final UserEntity user;
  final String token;

  const LoginEntity({
    required this.message,
    required this.user,
    required this.token,
  });

  @override
  List<Object?> get props => [message, user, token];
}
