import 'package:equatable/equatable.dart';
import 'package:super_fitness/config/network/app_error.dart';

sealed class AppFailure extends Equatable {
  const AppFailure();

  @override
  List<Object?> get props => [];
}

final class NetworkFailure extends AppFailure {
  final AppError error;
  const NetworkFailure(this.error);

  @override
  List<Object?> get props => [error];
}

final class ServerMessageFailure extends AppFailure {
  final String message;
  const ServerMessageFailure(this.message);

  @override
  List<Object?> get props => [message];
}
