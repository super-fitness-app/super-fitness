import 'package:super_fitness/core/errors/app_failure.dart';

export 'package:super_fitness/core/errors/app_failure.dart';

sealed class ApiResults<T> {
  const ApiResults();
}

class Success<T> extends ApiResults<T> {
  final T data;
  const Success(this.data);
}

class FailureResponse<T> extends ApiResults<T> {
  final AppFailure failure;
  const FailureResponse(this.failure);
}

typedef Failure<T> = FailureResponse<T>;
