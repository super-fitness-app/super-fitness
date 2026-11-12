import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';

@injectable
class DeleteSessionUseCase {
  final ChatRepository _chatRepository;

  const DeleteSessionUseCase(this._chatRepository);

  Future<ApiResults<void>> call(String sessionId) {
    return _chatRepository.deleteSession(sessionId);
  }
}
