import 'package:super_fitness/core/errors/app_failure.dart';

sealed class BaseEvent {
  const BaseEvent();
}

class DisplayError extends BaseEvent {
  final String? errorMsg;
  final AppFailure? failure;

  const DisplayError(this.errorMsg, {this.failure});

  factory DisplayError.fromFailure(
    AppFailure failure, [
    String? fallback,
  ]) =>
      DisplayError(
        failure is ServerMessageFailure ? failure.message : fallback,
        failure: failure,
      );
}

class DisplaySuccess extends BaseEvent {
  final String successMsg;
  const DisplaySuccess(this.successMsg);
}

class NavigateEvent extends BaseEvent {
  final String routeName;
  final Object? extra;
  const NavigateEvent(this.routeName, {this.extra});
}

abstract base class FeatureEvent extends BaseEvent {
  const FeatureEvent();
}
