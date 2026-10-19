import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/dio/dio_module.dart';
import 'package:super_fitness/config/interceptors/auth_interceptor.dart';
import 'package:super_fitness/config/session/session_service.dart';

class _FakeSessionService implements SessionService {
  @override
  Future<void> clearSession() async {}

  @override
  Future<String> getRefreshToken() async => '';

  @override
  Future<String> getToken() async => '';

  @override
  Future<bool> isGuest() async => false;

  @override
  Future<bool> isRemembered() async => false;

  @override
  Future<void> saveTokens({
    required String token,
    required String refreshToken,
    bool rememberMe = true,
  }) async {}

  @override
  Future<void> setGuestMode(bool value) async {}

  @override
  Future<void> setRememberMe(bool value) async {}

  @override
  Future<void> updateTokens({
    required String token,
    required String refreshToken,
  }) async {}
}

class _TestDioPackageModule extends DioPackageModule {}

void main() {
  group('DioModule Tests', () {
    test('refreshDioName constant has expected identifier', () {
      expect(DioModule.refreshDioName, 'refreshDio');
    });

    test('DioPackageModule provides refreshDio and standard dio instances', () {
      final module = _TestDioPackageModule();
      final refreshDio = module.refreshDio();
      expect(refreshDio, isNotNull);

      final interceptor = AuthInterceptor(_FakeSessionService());
      final standardDio = module.dio(interceptor);
      expect(standardDio, isNotNull);
      expect(standardDio.interceptors.contains(interceptor), isTrue);
    });
  });
}
