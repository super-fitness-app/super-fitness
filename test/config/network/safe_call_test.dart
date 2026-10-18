import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/config/network/safe_call.dart';

void main() {
  group('safeCall Tests', () {
    test('returns Success when call completes successfully', () async {
      final result = await safeCall<String>(() async {
        return const Success('data');
      });

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, 'data');
    });

    test('catches TypeError and returns NetworkFailure(AppError.badResponse)',
        () async {
      final result = await safeCall<String>(() async {
        final dynamic invalidData = 123;
        final String text = invalidData as String;
        return Success(text);
      });

      expect(result, isA<FailureResponse<String>>());
      final failure = (result as FailureResponse<String>).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).error, AppError.badResponse);
    });

    test('catches SocketException and returns NetworkFailure(AppError.noConnection)',
        () async {
      final result = await safeCall<String>(() async {
        throw const SocketException('No Internet');
      });

      expect(result, isA<FailureResponse<String>>());
      final failure = (result as FailureResponse<String>).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).error, AppError.noConnection);
    });

    test('catches FormatException and returns NetworkFailure(AppError.badResponse)',
        () async {
      final result = await safeCall<String>(() async {
        throw const FormatException('Malformed JSON');
      });

      expect(result, isA<FailureResponse<String>>());
      final failure = (result as FailureResponse<String>).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).error, AppError.badResponse);
    });

    test('inspects DioExceptionType.unknown with inner SocketException',
        () async {
      final dioException = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.unknown,
        error: const SocketException('Connection refused'),
      );

      final result = await safeCall<String>(() async {
        throw dioException;
      });

      expect(result, isA<FailureResponse<String>>());
      final failure = (result as FailureResponse<String>).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).error, AppError.noConnection);
    });

    test('inspects DioExceptionType.unknown with inner FormatException',
        () async {
      final dioException = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.unknown,
        error: const FormatException('Unexpected character'),
      );

      final result = await safeCall<String>(() async {
        throw dioException;
      });

      expect(result, isA<FailureResponse<String>>());
      final failure = (result as FailureResponse<String>).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).error, AppError.badResponse);
    });

    test('extracts direct String error message from bad response', () async {
      final dioException = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: 400,
          data: {'message': 'Invalid credentials'},
        ),
      );

      final result = await safeCall<String>(() async {
        throw dioException;
      });

      expect(result, isA<FailureResponse<String>>());
      final failure = (result as FailureResponse<String>).failure;
      expect(failure, isA<ServerMessageFailure>());
      expect(
        (failure as ServerMessageFailure).message,
        'Invalid credentials',
      );
    });

    test('extracts nested String message from error map in bad response',
        () async {
      final dioException = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: 400,
          data: {
            'error': {'message': 'Nested error message'}
          },
        ),
      );

      final result = await safeCall<String>(() async {
        throw dioException;
      });

      expect(result, isA<FailureResponse<String>>());
      final failure = (result as FailureResponse<String>).failure;
      expect(failure, isA<ServerMessageFailure>());
      expect(
        (failure as ServerMessageFailure).message,
        'Nested error message',
      );
    });

    test('does NOT stringify technical map without message and falls back to statusCode',
        () async {
      final dioException = DioException(
        requestOptions: RequestOptions(),
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: RequestOptions(),
          statusCode: 401,
          data: {
            'error': {'code': 401, 'internal': true}
          },
        ),
      );

      final result = await safeCall<String>(() async {
        throw dioException;
      });

      expect(result, isA<FailureResponse<String>>());
      final failure = (result as FailureResponse<String>).failure;
      expect(failure, isA<NetworkFailure>());
      expect((failure as NetworkFailure).error, AppError.unauthorized);
    });
  });
}
