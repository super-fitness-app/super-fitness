import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:super_fitness/features/ai_chat/core/constants/ai_constants.dart';

abstract final class PlatformHostResolver {
  static String resolveChatEndpoint() {
    try {
      if (Platform.isAndroid) {
        return AiConstants.androidHost;
      }
    } catch (e) {
      debugPrint('[AiChat] PlatformHostResolver platform check: $e');
    }
    return AiConstants.desktopHost;
  }
}
