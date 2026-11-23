import 'package:equatable/equatable.dart';

class LogoutEntity extends Equatable {
  final String message;

  const LogoutEntity({required this.message});

  @override
  List<Object?> get props => [message];
}
