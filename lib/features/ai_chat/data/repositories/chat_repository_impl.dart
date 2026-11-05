import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/safe_call.dart';
import 'package:super_fitness/features/ai_chat/core/utils/chat_message_mapper.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/local/fitness_local_data_source.dart';
import 'package:super_fitness/features/ai_chat/data/services/ai_agent_service.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final AiAgentService _aiAgentService;
  final FitnessLocalDataSource _localDataSource;

  const ChatRepositoryImpl(
    this._aiAgentService,
    this._localDataSource,
  );

  @override
  Future<ApiResults<List<ChatMessageEntity>>> getMessages() async {
    return safeCall(() async {
      final models = await _localDataSource.getCachedMessages();
      return Success(ChatMessageMapper.toEntityList(models));
    });
  }

  @override
  Future<ApiResults<ChatMessageEntity>> sendMessage(String message) async {
    return safeCall(() async {
      final cached = await _localDataSource.getCachedMessages();
      final responseModel = await _aiAgentService.runAgentLoop(cached);
      await _localDataSource.saveMessage(responseModel);
      return Success(ChatMessageMapper.toEntity(responseModel));
    });
  }

  @override
  Future<ApiResults<void>> clearChat() async {
    return safeCall(() async {
      await _localDataSource.clearMessages();
      return const Success(null);
    });
  }
}
