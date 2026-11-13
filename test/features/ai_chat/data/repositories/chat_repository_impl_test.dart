import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/ai_chat/core/errors/ai_chat_exception.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/contract/ai_remote_data_source.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/contract/fitness_local_data_source.dart';
import 'package:super_fitness/features/ai_chat/data/models/chat_message_model.dart';
import 'package:super_fitness/features/ai_chat/data/repositories/chat_repository_impl.dart';

class MockFitnessLocalDataSource extends Mock
    implements FitnessLocalDataSource {}

class MockAiRemoteDataSource extends Mock implements AiRemoteDataSource {
  @override
  Future<ChatMessageModel> sendMessage({dynamic message, dynamic sessionId}) =>
      super.noSuchMethod(
            Invocation.method(#sendMessage, [], {
              #message: message,
              #sessionId: sessionId,
            }),
            returnValue: Future.value(
              ChatMessageModel(
                id: '1',
                role: 'assistant',
                content: 'Response',
                timestamp: DateTime(2026),
              ),
            ),
          )
          as Future<ChatMessageModel>;
}

void main() {
  late MockFitnessLocalDataSource mockLocal;
  late MockAiRemoteDataSource mockRemote;
  late ChatRepositoryImpl repository;

  setUp(() {
    mockLocal = MockFitnessLocalDataSource();
    mockRemote = MockAiRemoteDataSource();
    repository = ChatRepositoryImpl(mockLocal, mockRemote);
  });

  group('ChatRepositoryImpl Tests', () {
    test(
      'sendMessage returns Success with entity when remote succeeds',
      () async {
        final model = ChatMessageModel(
          id: '123',
          role: 'assistant',
          content: 'Personalized workout ready',
          timestamp: DateTime(2026),
        );

        when(
          mockRemote.sendMessage(
            message: 'Plan workout',
            sessionId: 'session_1',
          ),
        ).thenAnswer((_) async => model);

        final result = await repository.sendMessage(
          message: 'Plan workout',
          sessionId: 'session_1',
        );

        expect(result, isA<Success>());
        final entity = (result as Success).data;
        expect(entity.id, equals('123'));
        expect(entity.role, equals('assistant'));
        expect(entity.content, equals('Personalized workout ready'));
      },
    );

    test(
      'sendMessage returns FailureResponse with AiChatFailure on AiChatException',
      () async {
        when(
          mockRemote.sendMessage(
            message: anyNamed('message'),
            sessionId: anyNamed('sessionId'),
          ),
        ).thenThrow(const AiChatException('Model unavailable'));

        final result = await repository.sendMessage(
          message: 'Hello',
          sessionId: 'session_1',
        );

        expect(result, isA<FailureResponse>());
        final failure = (result as FailureResponse).failure;
        expect(failure, isA<AiChatFailure>());
        expect((failure as AiChatFailure).message, equals('Model unavailable'));
      },
    );

    test(
      'sendMessage returns ServerMessageFailure on generic Exception',
      () async {
        when(
          mockRemote.sendMessage(
            message: anyNamed('message'),
            sessionId: anyNamed('sessionId'),
          ),
        ).thenThrow(Exception('Unknown network failure'));

        final result = await repository.sendMessage(
          message: 'Hello',
          sessionId: 'session_1',
        );

        expect(result, isA<FailureResponse>());
        final failure = (result as FailureResponse).failure;
        expect(failure, isA<ServerMessageFailure>());
      },
    );
  });
}
