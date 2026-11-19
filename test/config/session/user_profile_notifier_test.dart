import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/config/session/user_profile_notifier.dart';

class _FakeSessionService implements SessionService {
  String _userData = '';

  @override
  Future<void> saveUserData(String userData) async {
    _userData = userData;
  }

  @override
  Future<String> getUserData() async => _userData;

  @override
  Future<void> clearSession() async {
    _userData = '';
  }

  @override
  Future<String> getToken() async => '';

  @override
  Future<String> getRefreshToken() async => '';

  @override
  Future<bool> isGuest() async => false;

  @override
  Future<bool> isRemembered() async => true;

  @override
  Future<void> saveTokens({
    required String token,
    String? refreshToken,
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

void main() {
  group('UserProfileNotifier Tests', () {
    late _FakeSessionService sessionService;

    setUp(() {
      sessionService = _FakeSessionService();
      UserProfileNotifier.clear();
    });

    test('initial values are null', () {
      expect(UserProfileNotifier.userPhoto.value, isNull);
      expect(UserProfileNotifier.userName.value, isNull);
    });

    test('init loads photo and name from session service', () async {
      final json = jsonEncode({
        'photo': 'https://photo.png',
        'firstName': 'John',
      });
      await sessionService.saveUserData(json);

      await UserProfileNotifier.init(sessionService);

      expect(UserProfileNotifier.userPhoto.value, 'https://photo.png');
      expect(UserProfileNotifier.userName.value, 'John');
    });

    test('updatePhoto updates notifier value and persists to session service', () async {
      await UserProfileNotifier.updatePhoto(
        'https://new-photo.png',
        sessionService,
      );

      expect(UserProfileNotifier.userPhoto.value, 'https://new-photo.png');

      final saved = await sessionService.getUserData();
      final decoded = jsonDecode(saved);
      expect(decoded['photo'], 'https://new-photo.png');
    });

    test('updatePhoto with empty string resets userPhoto to null', () async {
      await UserProfileNotifier.updatePhoto('https://photo.png');
      expect(UserProfileNotifier.userPhoto.value, 'https://photo.png');

      await UserProfileNotifier.updatePhoto('');
      expect(UserProfileNotifier.userPhoto.value, isNull);
    });

    test('clear resets all values to null', () {
      UserProfileNotifier.userPhoto.value = 'https://photo.png';
      UserProfileNotifier.userName.value = 'John';

      UserProfileNotifier.clear();

      expect(UserProfileNotifier.userPhoto.value, isNull);
      expect(UserProfileNotifier.userName.value, isNull);
    });
  });
}
