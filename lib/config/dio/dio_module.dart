import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/interceptors/auth_interceptor.dart';
import 'package:super_fitness/core/const/endpoints.dart';

abstract final class DioModule {
  static const String refreshDioName = 'refreshDio';
}

@module
abstract class DioPackageModule {
  @Named(DioModule.refreshDioName)
  @lazySingleton
  Dio refreshDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }

    return dio;
  }

  @lazySingleton
  Dio dio(AuthInterceptor authInterceptor) {
    final dio = Dio(
      BaseOptions(
        baseUrl: Endpoints.baseUrl,
        sendTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(authInterceptor);

    if (kDebugMode) {
      dio.interceptors.add(
        LogInterceptor(
          request: true,
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }

    return dio;
  }
}
