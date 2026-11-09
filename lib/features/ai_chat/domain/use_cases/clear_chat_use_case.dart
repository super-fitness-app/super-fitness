import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';

@injectable
class ClearChatUseCase {
  final ChatRepository _chatRepository;

  const ClearChatUseCase(this._chatRepository);

  Future<ApiResults<void>> call({String sessionId = 'default_session'}) {
    return _chatRepository.clearChatHistory(sessionId: sessionId);
  }
}
