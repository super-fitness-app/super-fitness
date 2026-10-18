import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_constants.dart';
import 'package:super_fitness/core/localization/locale_cubit.dart';

class FakeStorageService implements StorageService {
  final Map<String, String> data = {};
  bool shouldThrowOnGet = false;
  bool shouldThrowOnSave = false;

  @override
  Future<void> save(String key, String value) async {
    if (shouldThrowOnSave) throw Exception('Save failed');
    data[key] = value;
  }

  @override
  Future<String> get(String key) async {
    if (shouldThrowOnGet) throw Exception('Get failed');
    return data[key] ?? '';
  }

  @override
  Future<void> delete(String key) async {
    data.remove(key);
  }
}

void main() {
  group('LocaleCubit Tests', () {
    late FakeStorageService storage;

    setUp(() {
      storage = FakeStorageService();
    });

    test('initial state defaults to English when storage is empty', () async {
      final cubit = LocaleCubit(storage);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, const Locale(AppConstants.localeEnglish));
      await cubit.close();
    });

    test('loads saved Arabic locale on initialization', () async {
      storage.data[AppConstants.localeKey] = AppConstants.localeArabic;

      final cubit = LocaleCubit(storage);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, const Locale(AppConstants.localeArabic));
      await cubit.close();
    });

    test('loads saved English locale on initialization', () async {
      storage.data[AppConstants.localeKey] = AppConstants.localeEnglish;

      final cubit = LocaleCubit(storage);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, const Locale(AppConstants.localeEnglish));
      await cubit.close();
    });

    test('retains fallback locale if reading storage throws', () async {
      storage.shouldThrowOnGet = true;

      final cubit = LocaleCubit(storage);
      await Future<void>.delayed(Duration.zero);

      expect(cubit.state, const Locale(AppConstants.localeEnglish));
      await cubit.close();
    });

    test('changeLocale persists new locale and emits new state', () async {
      final cubit = LocaleCubit(storage);
      await Future<void>.delayed(Duration.zero);

      const arabic = Locale(AppConstants.localeArabic);
      await cubit.changeLocale(arabic);

      expect(cubit.state, arabic);
      expect(storage.data[AppConstants.localeKey], AppConstants.localeArabic);
      await cubit.close();
    });

    test('changeLocale ignores duplicate locale emissions', () async {
      final cubit = LocaleCubit(storage);
      await Future<void>.delayed(Duration.zero);

      final states = <Locale>[];
      final subscription = cubit.stream.listen(states.add);

      const english = Locale(AppConstants.localeEnglish);
      await cubit.changeLocale(english);

      expect(states, isEmpty);
      await subscription.cancel();
      await cubit.close();
    });

    test('changeLocale retains previous state when storage fails', () async {
      final cubit = LocaleCubit(storage);
      await Future<void>.delayed(Duration.zero);

      storage.shouldThrowOnSave = true;
      const arabic = Locale(AppConstants.localeArabic);
      await cubit.changeLocale(arabic);

      expect(cubit.state, const Locale(AppConstants.localeEnglish));
      await cubit.close();
    });
  });
}
