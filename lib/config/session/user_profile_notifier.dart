import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:super_fitness/config/session/session_service.dart';

class UserProfileNotifier {
  UserProfileNotifier._();

  static final ValueNotifier<String?> userPhoto = ValueNotifier<String?>(null);
  static final ValueNotifier<String?> userName = ValueNotifier<String?>(null);

  /// Initializes the notifier from [SessionService]
  static Future<void> init(SessionService sessionService) async {
    try {
      final userDataStr = await sessionService.getUserData();
      if (userDataStr.isNotEmpty) {
        final Map<String, dynamic> json = jsonDecode(userDataStr);
        final photo = json['photo'] as String?;
        final firstName = json['firstName'] as String?;
        if (photo != null && photo.trim().isNotEmpty) {
          userPhoto.value = photo.trim();
        }
        if (firstName != null && firstName.trim().isNotEmpty) {
          userName.value = firstName.trim();
        }
      }
    } catch (_) {}
  }

  /// Updates the user's photo and persists it via [sessionService] if provided
  static Future<void> updatePhoto(
    String newPhoto, [
    SessionService? sessionService,
  ]) async {
    userPhoto.value = newPhoto.trim().isNotEmpty ? newPhoto.trim() : null;

    if (sessionService != null) {
      try {
        final userDataStr = await sessionService.getUserData();
        Map<String, dynamic> json = {};
        if (userDataStr.isNotEmpty) {
          json = jsonDecode(userDataStr) as Map<String, dynamic>;
        }
        json['photo'] = newPhoto;
        await sessionService.saveUserData(jsonEncode(json));
      } catch (_) {}
    }
  }

  /// Clears in-memory profile data
  static void clear() {
    userPhoto.value = null;
    userName.value = null;
  }
}
