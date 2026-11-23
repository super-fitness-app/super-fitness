import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';

@injectable
class SendMessageUseCase {
  final ChatRepository _chatRepository;

  const SendMessageUseCase(this._chatRepository);

  Future<ApiResults<ChatMessageEntity>> call({
    required String message,
    String sessionId = 'default_session',
  }) {
    return _chatRepository.sendMessage(message: message, sessionId: sessionId);
  }
}
