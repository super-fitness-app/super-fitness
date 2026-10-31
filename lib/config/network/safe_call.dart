import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/core/const/api_params.dart';

Future<ApiResults<T>> safeCall<T>(Future<ApiResults<T>> Function() call) async {
  try {
    return await call();
  } on Exception catch (e) {
    return FailureResponse(errorParser(e));
  } on Error catch (_) {
    return const FailureResponse(NetworkFailure(AppError.badResponse));
  }
}

AppFailure errorParser(Exception exception) {
  if (exception is FirebaseException) {
    return _handleFirebaseException(exception);
  }
  if (exception is DioException) {
    return _handleDioException(exception);
  }
  if (exception is SocketException) {
    return const NetworkFailure(AppError.noConnection);
  }
  if (exception is FormatException) {
    return const NetworkFailure(AppError.badResponse);
  }
  return const NetworkFailure(AppError.unknown);
}

AppFailure _handleFirebaseException(FirebaseException exception) {
  switch (exception.code) {
    case 'network-request-failed':
      return const NetworkFailure(AppError.noConnection);
    case 'user-disabled':
      return const ServerMessageFailure('This account has been disabled.');
    case 'invalid-credential':
    case 'invalid-verification-code':
    case 'invalid-verification-id':
      return const ServerMessageFailure('Invalid Google credentials.');
    case 'operation-not-allowed':
      return const ServerMessageFailure('Google sign-in is not enabled.');
    case 'account-exists-with-different-credential':
      return const ServerMessageFailure(
        'An account already exists with the same email address.',
      );
    default:
      return ServerMessageFailure(
        exception.message ?? 'Google authentication failed.',
      );
  }
}

AppFailure _handleDioException(DioException exception) {
  switch (exception.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const NetworkFailure(AppError.timeout);
    case DioExceptionType.badCertificate:
      return const NetworkFailure(AppError.security);
    case DioExceptionType.badResponse:
      return _handleBadResponse(exception);
    case DioExceptionType.connectionError:
      return const NetworkFailure(AppError.noConnection);
    case DioExceptionType.cancel:
      return const NetworkFailure(AppError.cancelled);
    case DioExceptionType.unknown:
    default:
      return _handleUnknownDioException(exception);
  }
}

AppFailure _handleUnknownDioException(DioException exception) {
  final innerError = exception.error;
  if (innerError is SocketException) {
    return const NetworkFailure(AppError.noConnection);
  }
  if (innerError is FormatException) {
    return const NetworkFailure(AppError.badResponse);
  }
  return const NetworkFailure(AppError.unknown);
}

AppFailure _handleBadResponse(DioException exception) {
  final message = _extractErrorMessage(exception.response?.data);
  if (message != null && message.trim().isNotEmpty) {
    return ServerMessageFailure(message);
  }

  final statusCode = exception.response?.statusCode;
  if (statusCode != null && statusCode >= 500) {
    return const NetworkFailure(AppError.server);
  }

  final error = _mapStatusCodeToAppError(statusCode);
  return NetworkFailure(error);
}

AppError _mapStatusCodeToAppError(int? statusCode) {
  return switch (statusCode) {
    400 => AppError.badRequest,
    401 => AppError.unauthorized,
    403 => AppError.forbidden,
    404 => AppError.notFound,
    409 => AppError.conflict,
    422 => AppError.validation,
    429 => AppError.tooManyRequests,
    _ => AppError.unknown,
  };
}

String? _extractErrorMessage(dynamic responseData) {
  if (responseData is Map<String, dynamic>) {
    final direct =
        responseData[ApiParams.message] ?? responseData[ApiParams.msg];
    if (direct is String && direct.trim().isNotEmpty) return direct.trim();

    final err = responseData[ApiParams.error];
    if (err is String && err.trim().isNotEmpty) return err.trim();
    if (err is Map<String, dynamic>) {
      final nested = err[ApiParams.message] ?? err[ApiParams.msg];
      if (nested is String && nested.trim().isNotEmpty) return nested.trim();
    }

    return _extractFromErrorsList(responseData[ApiParams.errors]);
  }
  return responseData is String && responseData.trim().isNotEmpty
      ? responseData.trim()
      : null;
}

String? _extractFromErrorsList(dynamic errors) {
  if (errors is! List || errors.isEmpty) return null;
  final first = errors.first;
  if (first is Map<String, dynamic>) {
    final nested = first[ApiParams.message] ?? first[ApiParams.msg];
    if (nested is String && nested.trim().isNotEmpty) return nested.trim();
  } else if (first is String && first.trim().isNotEmpty) {
    return first.trim();
  }
  return null;
}
