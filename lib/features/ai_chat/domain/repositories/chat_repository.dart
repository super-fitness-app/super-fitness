import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';

abstract interface class ChatRepository {
  Future<ApiResults<List<ChatMessageEntity>>> getMessages();
  Future<ApiResults<ChatMessageEntity>> sendMessage(String message);
  Future<ApiResults<void>> clearChat();
}
