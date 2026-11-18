import 'package:equatable/equatable.dart';

class SocialAuthUserEntity extends Equatable {
  final String? id;
  final String email;
  final String displayName;
  final String? photoUrl;

  const SocialAuthUserEntity({
    this.id,
    required this.email,
    required this.displayName,
    this.photoUrl,
  });

  @override
  List<Object?> get props => [id, email, displayName, photoUrl];
}
