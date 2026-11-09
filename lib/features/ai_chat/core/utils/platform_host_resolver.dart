import 'dart:io';
import 'package:super_fitness/features/ai_chat/core/constants/ai_constants.dart';

abstract final class PlatformHostResolver {
  static String resolveChatEndpoint() {
    try {
      if (Platform.isAndroid) {
        return AiConstants.androidHost;
      }
    } catch (_) {}
    return AiConstants.desktopHost;
  }
}
