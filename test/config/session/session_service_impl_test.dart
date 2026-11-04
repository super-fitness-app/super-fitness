import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/config/session/session_service_impl.dart';
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
    late SessionService sessionService;

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

    test(
      'setGuestMode and isGuest persist correctly and clear in-memory tokens',
      () async {
        await sessionService.saveTokens(
          token: 'initial_token',
          refreshToken: 'initial_refresh',
          rememberMe: false,
        );

        await sessionService.setGuestMode(true);
        expect(await sessionService.isGuest(), isTrue);
        expect(storage.data[AppConstants.guestModeKey], 'true');

        expect(await sessionService.getToken(), isEmpty);
        expect(await sessionService.getRefreshToken(), isEmpty);

        await sessionService.setGuestMode(false);
        expect(await sessionService.isGuest(), isFalse);
      },
    );

    test(
      'saveTokens with rememberMe=true persists to storage and memory',
      () async {
        await sessionService.saveTokens(
          token: 'test_token',
          refreshToken: 'test_refresh',
          rememberMe: true,
        );

        expect(await sessionService.getToken(), 'test_token');
        expect(await sessionService.getRefreshToken(), 'test_refresh');
        expect(storage.data[AppConstants.storageTokenKey], 'test_token');
        expect(
          storage.data[AppConstants.storageRefreshTokenKey],
          'test_refresh',
        );
      },
    );

    test(
      'saveTokens with optional refreshToken omitted stores only token',
      () async {
        await sessionService.saveTokens(token: 'token_only', rememberMe: true);

        expect(await sessionService.getToken(), 'token_only');
        expect(await sessionService.getRefreshToken(), isEmpty);
        expect(storage.data[AppConstants.storageTokenKey], 'token_only');
        expect(storage.data[AppConstants.storageRefreshTokenKey], isNull);
      },
    );

    test(
      'saveTokens with rememberMe=false deletes from storage but keeps in memory',
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
      },
    );

    test(
      'updateTokens updates memory and only storage if isRemembered',
      () async {
        await sessionService.setRememberMe(false);
        await sessionService.updateTokens(
          token: 'new_token',
          refreshToken: 'new_refresh',
        );

        expect(await sessionService.getToken(), 'new_token');
        expect(storage.data[AppConstants.storageTokenKey], isNull);

        await sessionService.setRememberMe(true);
        await sessionService.updateTokens(
          token: 'new_token_2',
          refreshToken: 'new_refresh_2',
        );

        expect(await sessionService.getToken(), 'new_token_2');
        expect(storage.data[AppConstants.storageTokenKey], 'new_token_2');
        expect(
          storage.data[AppConstants.storageRefreshTokenKey],
          'new_refresh_2',
        );
      },
    );

    test('saveUserData and getUserData persist user data to storage', () async {
      await sessionService.saveUserData('{"id":"123","email":"test@test.com"}');
      expect(
        await sessionService.getUserData(),
        '{"id":"123","email":"test@test.com"}',
      );
      expect(
        storage.data[AppConstants.userDataKey],
        '{"id":"123","email":"test@test.com"}',
      );
    });

    test('clearSession clears memory and deletes all storage keys', () async {
      await sessionService.saveTokens(
        token: 'token',
        refreshToken: 'refresh',
        rememberMe: true,
      );
      await sessionService.setRememberMe(true);
      await sessionService.setGuestMode(true);
      await sessionService.saveUserData('{"id":"123"}');

      await sessionService.clearSession();

      expect(await sessionService.getToken(), isEmpty);
      expect(await sessionService.getRefreshToken(), isEmpty);
      expect(storage.data[AppConstants.storageTokenKey], isNull);
      expect(storage.data[AppConstants.storageRefreshTokenKey], isNull);
      expect(storage.data[AppConstants.rememberMeKey], isNull);
      expect(storage.data[AppConstants.guestModeKey], isNull);
      expect(storage.data[AppConstants.userDataKey], isNull);
    });
  });
}
