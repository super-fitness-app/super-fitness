import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';

@injectable
class GetChatHistoryUseCase {
  final ChatRepository _chatRepository;

  const GetChatHistoryUseCase(this._chatRepository);

  Future<ApiResults<List<ChatMessageEntity>>> call({
    String sessionId = 'default_session',
  }) {
    return _chatRepository.getChatHistory(sessionId: sessionId);
  }
}
