import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/core/errors/app_failure.dart';

void main() {
  group('BaseState Unit Tests', () {
    test('initial factory sets correct defaults', () {
      const state = BaseState<String>.initial();

      expect(state.isLoading, isFalse);
      expect(state.failure, isNull);
      expect(state.data, isNull);
      expect(state.errorMessage, isNull);
      expect(state.props, [false, null, null]);
    });

    test('loading factory sets isLoading to true and preserves optional data', () {
      final state = BaseState<String>.loading(data: 'cached');

      expect(state.isLoading, isTrue);
      expect(state.failure, isNull);
      expect(state.data, 'cached');
      expect(state.props, [true, null, 'cached']);
    });

    test('success factory sets data and resets loading and failure', () {
      final state = BaseState<int>.success(42);

      expect(state.isLoading, isFalse);
      expect(state.failure, isNull);
      expect(state.data, 42);
      expect(state.props, [false, null, 42]);
    });

    test('error factory creates ServerMessageFailure with given message', () {
      final state = BaseState<String>.error('Server crashed');

      expect(state.isLoading, isFalse);
      expect(state.failure, const ServerMessageFailure('Server crashed'));
      expect(state.errorMessage, 'Server crashed');
      expect(state.props, [false, const ServerMessageFailure('Server crashed'), null]);
    });

    test('failure factory sets typed AppFailure', () {
      const failure = NetworkFailure(AppError.noConnection);
      final state = BaseState<String>.failure(failure);

      expect(state.isLoading, isFalse);
      expect(state.failure, failure);
      expect(state.errorMessage, isNull);
      expect(state.props, [false, failure, null]);
    });

    test('copyWith updates specified fields and supports clearing with null', () {
      const initial = BaseState<String>(
        isLoading: false,
        failure: null,
        data: 'initial',
      );

      final updated = initial.copyWith(
        isLoading: true,
        data: 'updated',
        failure: const ServerMessageFailure('error'),
      );

      expect(updated.isLoading, isTrue);
      expect(updated.data, 'updated');
      expect(updated.failure, const ServerMessageFailure('error'));

      final cleared = updated.copyWith(
        data: null,
        failure: null,
      );

      expect(cleared.data, isNull);
      expect(cleared.failure, isNull);
      expect(cleared.isLoading, isTrue);
    });

    test('equatable value equality works correctly', () {
      const state1 = BaseState<String>(
        isLoading: false,
        failure: null,
        data: 'data',
      );
      const state2 = BaseState<String>(
        isLoading: false,
        failure: null,
        data: 'data',
      );
      const state3 = BaseState<String>(
        isLoading: true,
        failure: null,
        data: 'data',
      );

      expect(state1, equals(state2));
      expect(state1.hashCode, equals(state2.hashCode));
      expect(state1, isNot(equals(state3)));
    });

    test('toString formats correctly', () {
      const state = BaseState<String>.initial();
      expect(
        state.toString(),
        'BaseState(isLoading: false, data: null, failure: null)',
      );
    });
  });
}
