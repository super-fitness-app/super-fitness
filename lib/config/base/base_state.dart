import 'package:super_fitness/core/errors/app_failure.dart';

class Unset {
  const Unset();
}

const Unset unset = Unset();

class BaseState<T> {
  final bool isLoading;
  final AppFailure? failure;
  final T? data;

  const BaseState({
    required this.isLoading,
    required this.failure,
    required this.data,
  });

  const BaseState.initial()
      : this(isLoading: false, failure: null, data: null);

  factory BaseState.loading({T? data}) =>
      BaseState(isLoading: true, failure: null, data: data);

  factory BaseState.success(T data) =>
      BaseState(isLoading: false, failure: null, data: data);

  factory BaseState.error(String message, {T? data, AppFailure? failure}) =>
      BaseState(
        isLoading: false,
        failure: failure ?? ServerMessageFailure(message),
        data: data,
      );

  factory BaseState.failure(AppFailure failure, {T? data}) =>
      BaseState(isLoading: false, failure: failure, data: data);

  String? get errorMessage => failure is ServerMessageFailure
      ? (failure as ServerMessageFailure).message
      : null;

  BaseState<T> copyWith({
    bool? isLoading,
    Object? data = unset,
    Object? failure = unset,
  }) {
    return BaseState<T>(
      isLoading: isLoading ?? this.isLoading,
      data: identical(data, unset) ? this.data : data as T?,
      failure: identical(failure, unset) ? this.failure : failure as AppFailure?,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BaseState<T> &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          failure == other.failure &&
          data == other.data;

  @override
  int get hashCode => Object.hash(isLoading, failure, data);

  @override
  String toString() =>
      'BaseState(isLoading: $isLoading, data: $data, failure: $failure)';
}
