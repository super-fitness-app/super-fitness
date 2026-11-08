import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_session_entity.dart';

abstract interface class ChatRepository {
  Future<ApiResults<ChatMessageEntity>> sendMessage({
    required String message,
    String sessionId = 'default_session',
  });

  Stream<ChatMessageEntity> streamMessage({
    required String message,
    String sessionId = 'default_session',
  });

  Future<ApiResults<List<ChatMessageEntity>>> getChatHistory({
    String sessionId = 'default_session',
  });

  Future<ApiResults<void>> clearChatHistory({
    String sessionId = 'default_session',
  });

  Future<ApiResults<List<ChatSessionEntity>>> getChatSessions();

  Future<ApiResults<ChatSessionEntity>> createNewSession({String? title});

  Future<ApiResults<void>> deleteSession(String sessionId);
}
