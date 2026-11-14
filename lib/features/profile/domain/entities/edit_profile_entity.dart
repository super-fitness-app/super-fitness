import 'package:equatable/equatable.dart';
import 'package:super_fitness/features/auth/domain/entities/user_entity.dart';

class EditProfileEntity extends Equatable {
  final String message;
  final UserEntity user;

  const EditProfileEntity({required this.message, required this.user});

  @override
  List<Object?> get props => [message, user];
}
