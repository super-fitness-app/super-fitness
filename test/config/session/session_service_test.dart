import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_constants.dart';

class FakeStorageService implements StorageService {
  final Map<String, String> data = {};

  @override
  Future<void> save(String key, String value) async {
    data[key] = value;
  }

  @override
  Future<String> get(String key) async {
    return data[key] ?? '';
  }

  @override
  Future<void> delete(String key) async {
    data.remove(key);
  }
}

void main() {
  group('SessionServiceImpl Tests', () {
    late FakeStorageService storage;
    late SessionServiceImpl sessionService;

    setUp(() {
      storage = FakeStorageService();
      sessionService = SessionServiceImpl(storage);
    });

    test('setRememberMe and isRemembered persist correctly', () async {
      expect(await sessionService.isRemembered(), isFalse);

      await sessionService.setRememberMe(true);
      expect(await sessionService.isRemembered(), isTrue);
      expect(storage.data[AppConstants.rememberMeKey], 'true');

      await sessionService.setRememberMe(false);
      expect(await sessionService.isRemembered(), isFalse);
      expect(storage.data[AppConstants.rememberMeKey], 'false');
    });

    test('setGuestMode and isGuest persist correctly and clear in-memory tokens',
        () async {
      await sessionService.saveTokens(
        token: 'initial_token',
        refreshToken: 'initial_refresh',
        rememberMe: false,
      );

      await sessionService.setGuestMode(true);
      expect(await sessionService.isGuest(), isTrue);
      expect(storage.data[AppConstants.guestModeKey], 'true');

      // Tokens in memory should have been cleared
      expect(await sessionService.getToken(), isEmpty);
      expect(await sessionService.getRefreshToken(), isEmpty);

      await sessionService.setGuestMode(false);
      expect(await sessionService.isGuest(), isFalse);
    });

    test('saveTokens with rememberMe=true persists to storage and memory',
        () async {
      await sessionService.saveTokens(
        token: 'test_token',
        refreshToken: 'test_refresh',
        rememberMe: true,
      );

      expect(await sessionService.getToken(), 'test_token');
      expect(await sessionService.getRefreshToken(), 'test_refresh');
      expect(storage.data[AppConstants.storageTokenKey], 'test_token');
      expect(storage.data[AppConstants.storageRefreshTokenKey], 'test_refresh');
    });

    test('saveTokens with rememberMe=false deletes from storage but keeps in memory',
        () async {
      storage.data[AppConstants.storageTokenKey] = 'old_token';
      storage.data[AppConstants.storageRefreshTokenKey] = 'old_refresh';

      await sessionService.saveTokens(
        token: 'session_token',
        refreshToken: 'session_refresh',
        rememberMe: false,
      );

      expect(await sessionService.getToken(), 'session_token');
      expect(await sessionService.getRefreshToken(), 'session_refresh');
      expect(storage.data.containsKey(AppConstants.storageTokenKey), isFalse);
      expect(
        storage.data.containsKey(AppConstants.storageRefreshTokenKey),
        isFalse,
      );
    });

    test('getToken and getRefreshToken fetch from storage if inMemory is empty',
        () async {
      storage.data[AppConstants.storageTokenKey] = 'stored_token';
      storage.data[AppConstants.storageRefreshTokenKey] = 'stored_refresh';

      expect(await sessionService.getToken(), 'stored_token');
      expect(await sessionService.getRefreshToken(), 'stored_refresh');
    });

    test('updateTokens updates storage only when isRemembered is true',
        () async {
      await sessionService.setRememberMe(false);
      await sessionService.updateTokens(
        token: 'new_token_1',
        refreshToken: 'new_refresh_1',
      );

      expect(await sessionService.getToken(), 'new_token_1');
      expect(storage.data[AppConstants.storageTokenKey], isNull);

      await sessionService.setRememberMe(true);
      await sessionService.updateTokens(
        token: 'new_token_2',
        refreshToken: 'new_refresh_2',
      );

      expect(await sessionService.getToken(), 'new_token_2');
      expect(storage.data[AppConstants.storageTokenKey], 'new_token_2');
      expect(storage.data[AppConstants.storageRefreshTokenKey], 'new_refresh_2');
    });

    test('clearSession clears memory and deletes all storage keys', () async {
      await sessionService.saveTokens(
        token: 'token',
        refreshToken: 'refresh',
        rememberMe: true,
      );
      await sessionService.setRememberMe(true);
      await sessionService.setGuestMode(true);

      await sessionService.clearSession();

      expect(await sessionService.getToken(), isEmpty);
      expect(await sessionService.getRefreshToken(), isEmpty);
      expect(storage.data[AppConstants.storageTokenKey], isNull);
      expect(storage.data[AppConstants.storageRefreshTokenKey], isNull);
      expect(storage.data[AppConstants.rememberMeKey], isNull);
      expect(storage.data[AppConstants.guestModeKey], isNull);
    });
  });
}
