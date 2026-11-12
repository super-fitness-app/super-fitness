import 'package:super_fitness/core/const/endpoints.dart';

abstract final class AiConstants {
  static const String defaultModel = Endpoints.ollamaCloudModel;
  static const String androidHost = Endpoints.ollamaAndroidHost;
  static const String desktopHost = Endpoints.ollamaDesktopHost;
  static const Duration requestTimeout = Duration(seconds: 120);
  static const Duration receiveTimeout = Duration(seconds: 120);
  static const Duration firestoreTimeout = Duration(seconds: 3);
  static const String chatSessionsCollection = 'smart_coach_chats';
  static const String messagesCollection = 'messages';
  static const String usersCollection = 'users';
}
