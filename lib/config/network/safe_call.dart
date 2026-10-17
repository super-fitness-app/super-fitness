import 'package:dio/dio.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/core/const/api_params.dart';

Future<ApiResults<T>> safeCall<T>(Future<ApiResults<T>> Function() call) async {
  try {
    return await call();
  } on Exception catch (e) {
    return FailureResponse(errorParser(e));
  }
}

AppFailure errorParser(Exception exception) {
  if (exception is DioException) {
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
        return const NetworkFailure(AppError.unknown);
    }
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
    final rawMessage =
        (responseData[ApiParams.message] ??
                responseData[ApiParams.error] ??
                responseData[ApiParams.msg])
            ?.toString();
    if (rawMessage != null && rawMessage.trim().isNotEmpty) {
      return rawMessage;
    }

    final errors = responseData[ApiParams.errors];
    if (errors is List && errors.isNotEmpty) {
      final firstError = errors.first;
      if (firstError is Map<String, dynamic>) {
        final nestedMsg = firstError[ApiParams.message]?.toString();
        if (nestedMsg != null && nestedMsg.trim().isNotEmpty) {
          return nestedMsg;
        }
      } else if (firstError != null) {
        final nestedMsg = firstError.toString();
        if (nestedMsg.trim().isNotEmpty) {
          return nestedMsg;
        }
      }
    }
  } else if (responseData is String && responseData.trim().isNotEmpty) {
    return responseData;
  }

  return null;
}
