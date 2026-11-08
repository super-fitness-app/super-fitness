import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/contract/ai_remote_data_source.dart';
import 'package:super_fitness/features/ai_chat/data/models/chat_message_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/chat_session_model.dart';
import 'package:super_fitness/features/ai_chat/data/repositories/chat_repository_impl.dart';

class FakeAiRemoteDataSource implements AiRemoteDataSource {
  ChatMessageModel? messageToReturn;
  List<ChatMessageModel> historyToReturn = [];
  List<ChatSessionModel> sessionsToReturn = [];
  ChatSessionModel? createdSessionToReturn;
  bool throwException = false;
  String? capturedMessage;
  String? capturedSessionId;

  @override
  Future<ChatMessageModel> sendMessage({
    required String message,
    required String sessionId,
  }) async {
    capturedMessage = message;
    capturedSessionId = sessionId;
    if (throwException) {
      throw Exception('Dio error');
    }
    return messageToReturn!;
  }

  @override
  Stream<ChatMessageModel> streamMessage({
    required String message,
    required String sessionId,
  }) async* {
    capturedMessage = message;
    capturedSessionId = sessionId;
    if (throwException) {
      throw Exception('Dio error');
    }
    if (messageToReturn != null) {
      yield messageToReturn!;
    }
  }

  @override
  Future<List<ChatMessageModel>> getChatHistory({
    required String sessionId,
  }) async {
    capturedSessionId = sessionId;
    if (throwException) {
      throw Exception('Firestore error');
    }
    return historyToReturn;
  }

  @override
  Future<void> clearChatHistory({required String sessionId}) async {
    capturedSessionId = sessionId;
    if (throwException) {
      throw Exception('Firestore delete error');
    }
  }

  @override
  Future<List<ChatSessionModel>> getChatSessions() async {
    if (throwException) {
      throw Exception('Get sessions error');
    }
    return sessionsToReturn;
  }

  @override
  Future<ChatSessionModel> createNewSession({String? title}) async {
    if (throwException) {
      throw Exception('Create session error');
    }
    return createdSessionToReturn ??
        ChatSessionModel(
          id: 'test_session_id',
          title: title ?? 'New Session',
          createdAt: DateTime(2026),
          updatedAt: DateTime(2026),
        );
  }

  @override
  Future<void> deleteSession(String sessionId) async {
    capturedSessionId = sessionId;
    if (throwException) {
      throw Exception('Delete session error');
    }
  }
}

void main() {
  late FakeAiRemoteDataSource fakeRemote;
  late ChatRepositoryImpl repository;

  setUp(() {
    fakeRemote = FakeAiRemoteDataSource();
    repository = ChatRepositoryImpl(fakeRemote);
  });

  group('ChatRepositoryImpl', () {
    final testModel = ChatMessageModel(
      id: '1',
      role: 'assistant',
      content: 'Coach advice',
      timestamp: DateTime(2026),
    );

    test('sendMessage should return success with mapped entity', () async {
      fakeRemote.messageToReturn = testModel;

      final result = await repository.sendMessage(
        message: 'Help me',
        sessionId: 's1',
      );

      expect(result, isA<Success>());
      expect((result as Success).data.content, equals('Coach advice'));
      expect(fakeRemote.capturedMessage, equals('Help me'));
      expect(fakeRemote.capturedSessionId, equals('s1'));
    });

    test('streamMessage should emit mapped entities', () async {
      fakeRemote.messageToReturn = testModel;

      final stream = repository.streamMessage(
        message: 'Stream test',
        sessionId: 's1',
      );

      final list = await stream.toList();
      expect(list.length, equals(1));
      expect(list.first.content, equals('Coach advice'));
      expect(fakeRemote.capturedMessage, equals('Stream test'));
    });

    test('getChatHistory should return success with mapped list', () async {
      fakeRemote.historyToReturn = [testModel];

      final result = await repository.getChatHistory(sessionId: 's1');

      expect(result, isA<Success>());
      expect((result as Success).data.length, equals(1));
    });

    test('clearChatHistory should return success', () async {
      final result = await repository.clearChatHistory(sessionId: 's1');

      expect(result, isA<Success>());
      expect(fakeRemote.capturedSessionId, equals('s1'));
    });

    test('sendMessage should return failure on exception', () async {
      fakeRemote.throwException = true;

      final result = await repository.sendMessage(
        message: 'Help me',
        sessionId: 's1',
      );

      expect(result, isA<FailureResponse>());
    });
  });
}
