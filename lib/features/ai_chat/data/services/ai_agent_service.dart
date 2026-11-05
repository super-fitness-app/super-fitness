// ignore_for_file: unused_field

import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/remote/ai_remote_data_source.dart';
import 'package:super_fitness/features/ai_chat/data/models/chat_message_model.dart';
import 'package:super_fitness/features/ai_chat/data/services/system_prompt_service.dart';
import 'package:super_fitness/features/ai_chat/domain/tools/fitness_tool_executor.dart';

@lazySingleton
class AiAgentService {
  final AiRemoteDataSource _remoteDataSource;
  final FitnessToolExecutor _toolExecutor;
  final SystemPromptService _systemPromptService;

  const AiAgentService(
    this._remoteDataSource,
    this._toolExecutor,
    this._systemPromptService,
  );

  Future<ChatMessageModel> runAgentLoop(List<ChatMessageModel> history) async {
    return ChatMessageModel(
      id: '',
      content: '',
      role: 'assistant',
      timestamp: DateTime.now(),
    );
  }
}
