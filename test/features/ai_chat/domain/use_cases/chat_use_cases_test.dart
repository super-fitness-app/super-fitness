import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/clear_chat_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/get_chat_history_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/send_message_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/stream_message_use_case.dart';

class MockChatRepository extends Mock implements ChatRepository {
  @override
  Future<ApiResults<ChatMessageEntity>> sendMessage({
    required String message,
    String sessionId = 'default_session',
  }) =>
      super.noSuchMethod(
            Invocation.method(#sendMessage, [], {
              #message: message,
              #sessionId: sessionId,
            }),
            returnValue: Future.value(
              Success(
                ChatMessageEntity(
                  id: '1',
                  role: 'assistant',
                  content: 'Response',
                  timestamp: DateTime(2026),
                ),
              ),
            ),
          )
          as Future<ApiResults<ChatMessageEntity>>;

  @override
  Stream<ChatMessageEntity> streamMessage({
    required String message,
    String sessionId = 'default_session',
  }) =>
      super.noSuchMethod(
            Invocation.method(#streamMessage, [], {
              #message: message,
              #sessionId: sessionId,
            }),
            returnValue: Stream.fromIterable([
              ChatMessageEntity(
                id: '1',
                role: 'assistant',
                content: 'Streamed',
                timestamp: DateTime(2026),
              ),
            ]),
          )
          as Stream<ChatMessageEntity>;

  @override
  Future<ApiResults<List<ChatMessageEntity>>> getChatHistory({
    String sessionId = 'default_session',
  }) =>
      super.noSuchMethod(
            Invocation.method(#getChatHistory, [], {#sessionId: sessionId}),
            returnValue: Future.value(Success(<ChatMessageEntity>[])),
          )
          as Future<ApiResults<List<ChatMessageEntity>>>;

  @override
  Future<ApiResults<void>> clearChatHistory({
    String sessionId = 'default_session',
  }) =>
      super.noSuchMethod(
            Invocation.method(#clearChatHistory, [], {#sessionId: sessionId}),
            returnValue: Future.value(const Success(null)),
          )
          as Future<ApiResults<void>>;
}

void main() {
  late MockChatRepository mockRepository;

  setUp(() {
    mockRepository = MockChatRepository();
  });

  group('Chat Use Cases Tests', () {
    test('SendMessageUseCase executes repository.sendMessage', () async {
      final useCase = SendMessageUseCase(mockRepository);
      final expected = ChatMessageEntity(
        id: 'msg_1',
        role: 'assistant',
        content: 'Bench press 4x8',
        timestamp: DateTime(2026),
      );

      when(
        mockRepository.sendMessage(message: 'Hi', sessionId: 's1'),
      ).thenAnswer((_) async => Success(expected));

      final result = await useCase(message: 'Hi', sessionId: 's1');

      expect(result, isA<Success<ChatMessageEntity>>());
      expect((result as Success).data, equals(expected));
      verify(
        mockRepository.sendMessage(message: 'Hi', sessionId: 's1'),
      ).called(1);
    });

    test('StreamMessageUseCase forwards stream from repository', () async {
      final useCase = StreamMessageUseCase(mockRepository);
      final chunk = ChatMessageEntity(
        id: 'chunk_1',
        role: 'assistant',
        content: 'Analyzing...',
        timestamp: DateTime(2026),
      );

      when(
        mockRepository.streamMessage(message: 'Train', sessionId: 's1'),
      ).thenAnswer((_) => Stream.fromIterable([chunk]));

      final result = await useCase(message: 'Train', sessionId: 's1').toList();

      expect(result.length, equals(1));
      expect(result.first.content, equals('Analyzing...'));
    });

    test('GetChatHistoryUseCase executes repository.getChatHistory', () async {
      final useCase = GetChatHistoryUseCase(mockRepository);
      when(
        mockRepository.getChatHistory(sessionId: 's1'),
      ).thenAnswer((_) async => const Success([]));

      final result = await useCase(sessionId: 's1');

      expect(result, isA<Success<List<ChatMessageEntity>>>());
      verify(mockRepository.getChatHistory(sessionId: 's1')).called(1);
    });

    test('ClearChatUseCase executes repository.clearChatHistory', () async {
      final useCase = ClearChatUseCase(mockRepository);
      when(
        mockRepository.clearChatHistory(sessionId: 's1'),
      ).thenAnswer((_) async => const Success(null));

      final result = await useCase(sessionId: 's1');

      expect(result, isA<Success<void>>());
      verify(mockRepository.clearChatHistory(sessionId: 's1')).called(1);
    });
  });
}
