import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/base/base_state.dart';
import 'package:super_fitness/config/router/app_router.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_constants.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/cubit/onboarding_cubit.dart';
import 'package:super_fitness/features/auth/presentation/onboarding/cubit/onboarding_intent.dart';

class _FakeStorageService implements StorageService {
  final Map<String, String> _data = {};

  @override
  Future<void> save(String key, String value) async {
    _data[key] = value;
  }

  @override
  Future<String> get(String key) async {
    return _data[key] ?? '';
  }

  @override
  Future<void> delete(String key) async {
    _data.remove(key);
  }
}

void main() {
  group('OnboardingCubit Unit Tests', () {
    late _FakeStorageService storageService;
    late OnboardingCubit cubit;

    setUp(() {
      storageService = _FakeStorageService();
      cubit = OnboardingCubit(storageService);
    });

    tearDown(() async {
      await cubit.close();
    });

    test('initial state is BaseState.success(0)', () {
      expect(cubit.state, equals(BaseState.success(0)));
      expect(cubit.state.data, equals(0));
    });

    blocTest<OnboardingCubit, BaseState<int>>(
      'emits BaseState.success(pageIndex) on PageChangedIntent',
      build: () => cubit,
      act: (cubit) {
        cubit.doEvent(const PageChangedIntent(1));
        cubit.doEvent(const PageChangedIntent(2));
      },
      expect: () => [
        BaseState.success(1),
        BaseState.success(2),
      ],
    );

    test('SkipOnboardingIntent saves flag and emits NavigateEvent', () async {
      final events = <BaseEvent>[];
      final subscription = cubit.eventStream.listen(events.add);

      cubit.doEvent(const SkipOnboardingIntent());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final hasSeen =
          await storageService.get(AppConstants.hasSeenOnboardingKey);
      expect(hasSeen, equals('true'));
      expect(events.length, equals(1));
      expect(events.first, isA<NavigateEvent>());
      expect(
        (events.first as NavigateEvent).routeName,
        equals(AppRoutes.login),
      );

      await subscription.cancel();
    });

    test('CompleteOnboardingIntent saves flag and emits NavigateEvent',
        () async {
      final events = <BaseEvent>[];
      final subscription = cubit.eventStream.listen(events.add);

      cubit.doEvent(const CompleteOnboardingIntent());
      await Future<void>.delayed(const Duration(milliseconds: 50));

      final hasSeen =
          await storageService.get(AppConstants.hasSeenOnboardingKey);
      expect(hasSeen, equals('true'));
      expect(events.length, equals(1));
      expect(events.first, isA<NavigateEvent>());
      expect(
        (events.first as NavigateEvent).routeName,
        equals(AppRoutes.login),
      );

      await subscription.cancel();
    });
  });
}
