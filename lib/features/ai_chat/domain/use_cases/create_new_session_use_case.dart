import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_session_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';

@injectable
class CreateNewSessionUseCase {
  final ChatRepository _chatRepository;

  const CreateNewSessionUseCase(this._chatRepository);

  Future<ApiResults<ChatSessionEntity>> call({String? title}) {
    return _chatRepository.createNewSession(title: title);
  }
}
