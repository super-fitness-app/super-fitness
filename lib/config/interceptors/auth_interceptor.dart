import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/network_constants.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/core/const/api_headers.dart';

@lazySingleton
class AuthInterceptor extends Interceptor {
  final SessionService _sessionService;

  AuthInterceptor(this._sessionService);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (options.extra[NetworkConstants.requiresToken] == false) {
      return handler.next(options);
    }

    try {
      final token = await _sessionService.getToken();

      if (token.isNotEmpty) {
        options.headers[ApiHeaders.authorization] =
            '${ApiHeaders.bearerPrefix}$token';
      }
    } catch (error, stackTrace) {
      log(
        'Failed to retrieve authentication token',
        error: error,
        stackTrace: stackTrace,
      );
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    return handler.next(err);
  }
}
