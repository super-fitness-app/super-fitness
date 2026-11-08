import 'package:super_fitness/features/ai_chat/data/models/chat_message_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/chat_session_model.dart';

abstract interface class AiRemoteDataSource {
  Future<ChatMessageModel> sendMessage({
    required String message,
    required String sessionId,
  });

  Stream<ChatMessageModel> streamMessage({
    required String message,
    required String sessionId,
  });

  Future<List<ChatMessageModel>> getChatHistory({
    required String sessionId,
  });

  Future<void> clearChatHistory({
    required String sessionId,
  });

  Future<List<ChatSessionModel>> getChatSessions();

  Future<ChatSessionModel> createNewSession({String? title});

  Future<void> deleteSession(String sessionId);
}
