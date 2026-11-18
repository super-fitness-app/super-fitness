import 'package:equatable/equatable.dart';
import 'package:super_fitness/core/errors/app_failure.dart';

abstract class BaseEvent extends Equatable {
  const BaseEvent();

  @override
  List<Object?> get props => [];
}

class DisplayError extends BaseEvent {
  final String? errorMsg;
  final AppFailure? failure;

  const DisplayError(this.errorMsg, {this.failure});

  factory DisplayError.fromFailure(AppFailure failure, [String? fallback]) =>
      DisplayError(switch (failure) {
        ServerMessageFailure(:final message) => message,
        CancelledFailure(:final message) => message ?? fallback,
        _ => fallback,
      }, failure: failure);
}

class DisplaySuccess extends BaseEvent {
  final String successMsg;

  const DisplaySuccess(this.successMsg);
}
