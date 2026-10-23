import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/features/main_layout/body_layout/cubit/main_layout_cubit.dart';
import 'package:super_fitness/features/main_layout/body_layout/cubit/main_layout_intent.dart';

void main() {
  group('MainLayoutCubit Unit Tests', () {
    late MainLayoutCubit cubit;

    setUp(() {
      cubit = MainLayoutCubit();
    });

    tearDown(() async {
      await cubit.close();
    });

    test('initial state is BaseState.success(0)', () {
      expect(cubit.state, equals(BaseState.success(0)));
      expect(cubit.state.data, equals(0));
    });

    blocTest<MainLayoutCubit, BaseState<int>>(
      'emits BaseState.success(targetIndex) on valid ChangeTabIntent',
      build: () => cubit,
      act: (cubit) {
        cubit.doEvent(const ChangeTabIntent(1));
        cubit.doEvent(const ChangeTabIntent(2));
        cubit.doEvent(const ChangeTabIntent(3));
      },
      expect: () => [
        BaseState.success(1),
        BaseState.success(2),
        BaseState.success(3),
      ],
    );

    blocTest<MainLayoutCubit, BaseState<int>>(
      'ignores out of bounds or redundant ChangeTabIntent',
      build: () => cubit,
      act: (cubit) {
        cubit.doEvent(const ChangeTabIntent(0));
        cubit.doEvent(const ChangeTabIntent(-1));
        cubit.doEvent(const ChangeTabIntent(4));
        cubit.doEvent(Object());
      },
      expect: () => [],
    );
  });
}
