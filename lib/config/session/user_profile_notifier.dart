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
        final firstName = (json['firstName'] as String?)?.trim();
        final lastName = (json['lastName'] as String?)?.trim();
        final name = (json['name'] as String?)?.trim() ??
            (json['fullName'] as String?)?.trim();

        if (photo != null && photo.trim().isNotEmpty) {
          userPhoto.value = photo.trim();
        }

        String? resolvedName;
        if (firstName != null && firstName.isNotEmpty) {
          resolvedName = firstName;
        } else if (name != null && name.isNotEmpty) {
          resolvedName = name;
        } else if (lastName != null && lastName.isNotEmpty) {
          resolvedName = lastName;
        }

        if (resolvedName != null && resolvedName.isNotEmpty) {
          userName.value = resolvedName;
        }
      }
    } catch (_) {}
  }

  /// Updates the user's name and persists it via [sessionService] if provided
  static Future<void> updateName(
    String newName, [
    SessionService? sessionService,
  ]) async {
    userName.value = newName.trim().isNotEmpty ? newName.trim() : null;

    if (sessionService != null) {
      try {
        final userDataStr = await sessionService.getUserData();
        Map<String, dynamic> json = {};
        if (userDataStr.isNotEmpty) {
          json = jsonDecode(userDataStr) as Map<String, dynamic>;
        }
        json['firstName'] = newName;
        await sessionService.saveUserData(jsonEncode(json));
      } catch (_) {}
    }
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
