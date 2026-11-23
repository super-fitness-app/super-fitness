import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';

@injectable
class StreamMessageUseCase {
  final ChatRepository _chatRepository;

  const StreamMessageUseCase(this._chatRepository);

  Stream<ChatMessageEntity> call({
    required String message,
    String sessionId = 'default_session',
  }) {
    return _chatRepository.streamMessage(
      message: message,
      sessionId: sessionId,
    );
  }
}
