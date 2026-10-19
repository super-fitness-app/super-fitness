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
