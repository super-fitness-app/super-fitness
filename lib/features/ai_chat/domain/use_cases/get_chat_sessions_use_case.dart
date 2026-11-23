import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_session_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';

@injectable
class GetChatSessionsUseCase {
  final ChatRepository _chatRepository;

  const GetChatSessionsUseCase(this._chatRepository);

  Future<ApiResults<List<ChatSessionEntity>>> call() {
    return _chatRepository.getChatSessions();
  }
}
