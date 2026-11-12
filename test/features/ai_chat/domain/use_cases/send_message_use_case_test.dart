import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/network/app_error.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/send_message_use_case.dart';

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
                  content: 'Mock response',
                  timestamp: DateTime(2026),
                ),
              ),
            ),
          )
          as Future<ApiResults<ChatMessageEntity>>;
}

void main() {
  late MockChatRepository mockRepository;
  late SendMessageUseCase useCase;

  setUp(() {
    mockRepository = MockChatRepository();
    useCase = SendMessageUseCase(mockRepository);
  });

  group('SendMessageUseCase', () {
    final expectedMessage = ChatMessageEntity(
      id: '1',
      role: 'assistant',
      content: 'Coach reply',
      timestamp: DateTime(2026),
    );

    test('should return Success when repository succeeds', () async {
      when(
        mockRepository.sendMessage(
          message: 'Hello Coach',
          sessionId: 'session_1',
        ),
      ).thenAnswer((_) async => Success(expectedMessage));

      final result = await useCase(
        message: 'Hello Coach',
        sessionId: 'session_1',
      );

      expect(result, isA<Success<ChatMessageEntity>>());
      expect((result as Success).data, equals(expectedMessage));
      verify(
        mockRepository.sendMessage(
          message: 'Hello Coach',
          sessionId: 'session_1',
        ),
      ).called(1);
    });

    test('should return FailureResponse when repository fails', () async {
      const failure = NetworkFailure(AppError.server);
      when(
        mockRepository.sendMessage(
          message: 'Hello Coach',
          sessionId: 'session_1',
        ),
      ).thenAnswer((_) async => const FailureResponse(failure));

      final result = await useCase(
        message: 'Hello Coach',
        sessionId: 'session_1',
      );

      expect(result, isA<FailureResponse<ChatMessageEntity>>());
      expect((result as FailureResponse).failure, equals(failure));
    });
  });
}
