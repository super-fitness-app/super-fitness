import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/storage/storage_service.dart';
import 'package:super_fitness/core/const/app_constants.dart';

abstract interface class SessionService {
  Future<void> setRememberMe(bool value);
  Future<bool> isRemembered();
  Future<void> setGuestMode(bool value);
  Future<bool> isGuest();
  Future<void> saveTokens({
    required String token,
    required String refreshToken,
    bool rememberMe = true,
  });
  Future<void> updateTokens({
    required String token,
    required String refreshToken,
  });
  Future<String> getToken();
  Future<String> getRefreshToken();
  Future<void> clearSession();
}

@LazySingleton(as: SessionService)
class SessionServiceImpl implements SessionService {
  final StorageService _storage;
  String? _inMemoryToken;
  String? _inMemoryRefreshToken;

  SessionServiceImpl(this._storage);

  @override
  Future<void> setRememberMe(bool value) async {
    await _storage.save(AppConstants.rememberMeKey, value.toString());
  }

  @override
  Future<bool> isRemembered() async {
    final value = await _storage.get(AppConstants.rememberMeKey);
    return value == 'true';
  }

  @override
  Future<void> setGuestMode(bool value) async {
    _inMemoryToken = null;
    _inMemoryRefreshToken = null;
    await _storage.save(AppConstants.guestModeKey, value.toString());
  }

  @override
  Future<bool> isGuest() async {
    final value = await _storage.get(AppConstants.guestModeKey);
    return value == 'true';
  }

  @override
  Future<void> saveTokens({
    required String token,
    required String refreshToken,
    bool rememberMe = true,
  }) async {
    _inMemoryToken = token;
    _inMemoryRefreshToken = refreshToken;

    if (rememberMe) {
      await _storage.save(AppConstants.storageTokenKey, token);
      await _storage.save(AppConstants.storageRefreshTokenKey, refreshToken);
    } else {
      await _storage.delete(AppConstants.storageTokenKey);
      await _storage.delete(AppConstants.storageRefreshTokenKey);
    }
  }

  @override
  Future<void> updateTokens({
    required String token,
    required String refreshToken,
  }) async {
    _inMemoryToken = token;
    _inMemoryRefreshToken = refreshToken;

    final remembered = await isRemembered();
    if (remembered) {
      await _storage.save(AppConstants.storageTokenKey, token);
      await _storage.save(AppConstants.storageRefreshTokenKey, refreshToken);
    }
  }

  @override
  Future<String> getToken() async {
    if (_inMemoryToken?.isNotEmpty == true) {
      return _inMemoryToken!;
    }
    final storedToken = await _storage.get(AppConstants.storageTokenKey);
    if (storedToken.isNotEmpty) {
      _inMemoryToken = storedToken;
    }
    return storedToken;
  }

  @override
  Future<String> getRefreshToken() async {
    if (_inMemoryRefreshToken?.isNotEmpty == true) {
      return _inMemoryRefreshToken!;
    }
    final storedRefreshToken = await _storage.get(
      AppConstants.storageRefreshTokenKey,
    );
    if (storedRefreshToken.isNotEmpty) {
      _inMemoryRefreshToken = storedRefreshToken;
    }
    return storedRefreshToken;
  }

  @override
  Future<void> clearSession() async {
    _inMemoryToken = null;
    _inMemoryRefreshToken = null;

    await _storage.delete(AppConstants.storageTokenKey);
    await _storage.delete(AppConstants.storageRefreshTokenKey);
    await _storage.delete(AppConstants.rememberMeKey);
    await _storage.delete(AppConstants.guestModeKey);
  }
}
