import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/features/auth/api/data_source_impl/local/auth_local_data_source_impl.dart';
import 'package:super_fitness/features/auth/data/data_source/local/auth_local_data_source.dart';

class FakeSessionService implements SessionService {
  String? savedToken;
  String? savedRefreshToken;
  bool cleared = false;

  @override
  Future<void> saveTokens({
    required String token,
    required String refreshToken,
    bool rememberMe = true,
  }) async {
    savedToken = token;
    savedRefreshToken = refreshToken;
  }

  @override
  Future<String> getToken() async => savedToken ?? '';

  @override
  Future<void> clearSession() async {
    cleared = true;
    savedToken = null;
    savedRefreshToken = null;
  }

  @override
  Future<String> getRefreshToken() async => savedRefreshToken ?? '';

  @override
  Future<bool> isGuest() async => false;

  @override
  Future<bool> isRemembered() async => true;

  @override
  Future<void> setGuestMode(bool value) async {}

  @override
  Future<void> setRememberMe(bool value) async {}

  @override
  Future<void> updateTokens({
    required String token,
    required String refreshToken,
  }) async {
    savedToken = token;
    savedRefreshToken = refreshToken;
  }
}

void main() {
  group('AuthLocalDataSourceImpl Tests', () {
    late FakeSessionService fakeSessionService;
    late AuthLocalDataSource dataSource;

    setUp(() {
      fakeSessionService = FakeSessionService();
      dataSource = AuthLocalDataSourceImpl(fakeSessionService);
    });

    test('saveToken forwards token to SessionService', () async {
      await dataSource.saveToken('jwt_test_token_123');

      expect(fakeSessionService.savedToken, 'jwt_test_token_123');
      expect(fakeSessionService.savedRefreshToken, '');
    });

    test('getToken returns token from SessionService', () async {
      fakeSessionService.savedToken = 'stored_token_abc';

      final token = await dataSource.getToken();

      expect(token, 'stored_token_abc');
    });

    test('clear calls clearSession on SessionService', () async {
      fakeSessionService.savedToken = 'token_to_clear';

      await dataSource.clear();

      expect(fakeSessionService.cleared, isTrue);
      expect(fakeSessionService.savedToken, isNull);
    });
  });
}

