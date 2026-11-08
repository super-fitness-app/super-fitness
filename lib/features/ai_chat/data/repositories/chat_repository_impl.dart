import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/ai_chat/core/errors/ai_chat_exception.dart';
import 'package:super_fitness/features/ai_chat/core/utils/chat_message_mapper.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/contract/ai_remote_data_source.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_session_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final AiRemoteDataSource _remoteDataSource;

  const ChatRepositoryImpl(this._remoteDataSource);

  @override
  Future<ApiResults<ChatMessageEntity>> sendMessage({
    required String message,
    String sessionId = 'default_session',
  }) async {
    try {
      final model = await _remoteDataSource.sendMessage(
        message: message,
        sessionId: sessionId,
      );
      return Success(model.toDomain());
    } on AiChatException catch (e) {
      return FailureResponse(AiChatFailure(e.message));
    } catch (e) {
      return FailureResponse(ServerMessageFailure(e.toString()));
    }
  }

  @override
  Stream<ChatMessageEntity> streamMessage({
    required String message,
    String sessionId = 'default_session',
  }) {
    return _remoteDataSource
        .streamMessage(message: message, sessionId: sessionId)
        .map((model) => model.toDomain());
  }

  @override
  Future<ApiResults<List<ChatMessageEntity>>> getChatHistory({
    String sessionId = 'default_session',
  }) async {
    try {
      final models = await _remoteDataSource.getChatHistory(
        sessionId: sessionId,
      );
      return Success(models.map((m) => m.toDomain()).toList());
    } on AiChatException catch (e) {
      return FailureResponse(AiChatFailure(e.message));
    } catch (e) {
      return FailureResponse(ServerMessageFailure(e.toString()));
    }
  }

  @override
  Future<ApiResults<void>> clearChatHistory({
    String sessionId = 'default_session',
  }) async {
    try {
      await _remoteDataSource.clearChatHistory(sessionId: sessionId);
      return const Success(null);
    } on AiChatException catch (e) {
      return FailureResponse(AiChatFailure(e.message));
    } catch (e) {
      return FailureResponse(ServerMessageFailure(e.toString()));
    }
  }

  @override
  Future<ApiResults<List<ChatSessionEntity>>> getChatSessions() async {
    try {
      final models = await _remoteDataSource.getChatSessions();
      return Success(models.map((m) => m.toEntity()).toList());
    } on AiChatException catch (e) {
      return FailureResponse(AiChatFailure(e.message));
    } catch (e) {
      return FailureResponse(ServerMessageFailure(e.toString()));
    }
  }

  @override
  Future<ApiResults<ChatSessionEntity>> createNewSession({String? title}) async {
    try {
      final model = await _remoteDataSource.createNewSession(title: title);
      return Success(model.toEntity());
    } on AiChatException catch (e) {
      return FailureResponse(AiChatFailure(e.message));
    } catch (e) {
      return FailureResponse(ServerMessageFailure(e.toString()));
    }
  }

  @override
  Future<ApiResults<void>> deleteSession(String sessionId) async {
    try {
      await _remoteDataSource.deleteSession(sessionId);
      return const Success(null);
    } on AiChatException catch (e) {
      return FailureResponse(AiChatFailure(e.message));
    } catch (e) {
      return FailureResponse(ServerMessageFailure(e.toString()));
    }
  }
}
