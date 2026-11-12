import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/config/base/base_event.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_session_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/clear_chat_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/create_new_session_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/delete_session_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/get_chat_history_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/get_chat_sessions_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/send_message_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/stream_message_use_case.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_cubit.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_event.dart';

class MockSendMessageUseCase extends Mock implements SendMessageUseCase {
  @override
  Future<ApiResults<ChatMessageEntity>> call({
    dynamic message,
    dynamic sessionId = 'default_session',
  }) =>
      super.noSuchMethod(
            Invocation.method(#call, [], {
              #message: message,
              #sessionId: sessionId,
            }),
            returnValue: Future.value(
              Success(
                ChatMessageEntity(
                  id: 'resp_1',
                  role: 'assistant',
                  content: 'Fallback response',
                  timestamp: DateTime(2026),
                ),
              ),
            ),
          )
          as Future<ApiResults<ChatMessageEntity>>;
}

class MockGetChatHistoryUseCase extends Mock implements GetChatHistoryUseCase {
  @override
  Future<ApiResults<List<ChatMessageEntity>>> call({
    dynamic sessionId = 'default_session',
  }) =>
      super.noSuchMethod(
            Invocation.method(#call, [], {#sessionId: sessionId}),
            returnValue: Future.value(const Success(<ChatMessageEntity>[])),
          )
          as Future<ApiResults<List<ChatMessageEntity>>>;
}

class MockClearChatUseCase extends Mock implements ClearChatUseCase {
  @override
  Future<ApiResults<void>> call({dynamic sessionId = 'default_session'}) =>
      super.noSuchMethod(
            Invocation.method(#call, [], {#sessionId: sessionId}),
            returnValue: Future.value(const Success(null)),
          )
          as Future<ApiResults<void>>;
}

class MockSessionService extends Mock implements SessionService {
  @override
  Future<String> getUserData() => Future.value('');
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  User? get currentUser => null;
}

class MockStreamMessageUseCase extends Mock implements StreamMessageUseCase {
  @override
  Stream<ChatMessageEntity> call({
    dynamic message,
    dynamic sessionId = 'default_session',
  }) =>
      super.noSuchMethod(
            Invocation.method(#call, [], {
              #message: message,
              #sessionId: sessionId,
            }),
            returnValue: Stream<ChatMessageEntity>.empty(),
          )
          as Stream<ChatMessageEntity>;
}

class MockGetChatSessionsUseCase extends Mock
    implements GetChatSessionsUseCase {
  @override
  Future<ApiResults<List<ChatSessionEntity>>> call() =>
      super.noSuchMethod(
            Invocation.method(#call, []),
            returnValue: Future.value(const Success(<ChatSessionEntity>[])),
          )
          as Future<ApiResults<List<ChatSessionEntity>>>;
}

class MockCreateNewSessionUseCase extends Mock
    implements CreateNewSessionUseCase {
  @override
  Future<ApiResults<ChatSessionEntity>> call({dynamic title}) =>
      super.noSuchMethod(
            Invocation.method(#call, [], {#title: title}),
            returnValue: Future.value(
              Success(
                ChatSessionEntity(
                  id: 'new_s1',
                  title: title?.toString() ?? 'New Chat',
                  createdAt: DateTime(2026),
                  updatedAt: DateTime(2026),
                ),
              ),
            ),
          )
          as Future<ApiResults<ChatSessionEntity>>;
}

class MockDeleteSessionUseCase extends Mock implements DeleteSessionUseCase {
  @override
  Future<ApiResults<void>> call(dynamic sessionId) =>
      super.noSuchMethod(
            Invocation.method(#call, [sessionId]),
            returnValue: Future.value(const Success(null)),
          )
          as Future<ApiResults<void>>;
}

void main() {
  late MockSendMessageUseCase mockSendMessage;
  late MockGetChatHistoryUseCase mockGetHistory;
  late MockClearChatUseCase mockClearChat;
  late MockSessionService mockSessionService;
  late MockFirebaseAuth mockAuth;
  late MockStreamMessageUseCase mockStream;
  late MockGetChatSessionsUseCase mockGetSessions;
  late MockCreateNewSessionUseCase mockCreateSession;
  late MockDeleteSessionUseCase mockDeleteSession;
  late AiChatCubit cubit;

  setUp(() async {
    mockSendMessage = MockSendMessageUseCase();
    mockGetHistory = MockGetChatHistoryUseCase();
    mockClearChat = MockClearChatUseCase();
    mockSessionService = MockSessionService();
    mockAuth = MockFirebaseAuth();
    mockStream = MockStreamMessageUseCase();
    mockGetSessions = MockGetChatSessionsUseCase();
    mockCreateSession = MockCreateNewSessionUseCase();
    mockDeleteSession = MockDeleteSessionUseCase();

    when(mockGetSessions()).thenAnswer((_) async => const Success([]));
    when(
      mockGetHistory(sessionId: anyNamed('sessionId')),
    ).thenAnswer((_) async => const Success([]));

    cubit = AiChatCubit(
      mockSendMessage,
      mockGetHistory,
      mockClearChat,
      mockSessionService,
      mockAuth,
      mockStream,
      mockGetSessions,
      mockCreateSession,
      mockDeleteSession,
    );
    await Future<void>.delayed(Duration.zero);
  });

  tearDown(() async {
    await cubit.close();
  });

  group('AiChatCubit State Management Tests', () {
    test('token threshold limits are correctly evaluated in state', () {
      final state1999 = cubit.state.copyWith(currentSessionTokens: 1999);
      expect(state1999.isApproachingTokenLimit, isFalse);
      expect(state1999.isSessionLocked, isFalse);

      final state2500 = cubit.state.copyWith(currentSessionTokens: 2500);
      expect(state2500.isApproachingTokenLimit, isTrue);
      expect(state2500.isSessionLocked, isFalse);

      final state3000 = cubit.state.copyWith(currentSessionTokens: 3000);
      expect(state3000.isApproachingTokenLimit, isFalse);
      expect(state3000.isSessionLocked, isTrue);
    });

    test('blocks message sending when session reaches 3000 tokens', () async {
      final events = <BaseEvent>[];
      final sub = cubit.eventStream.listen(events.add);

      cubit.emit(cubit.state.copyWith(currentSessionTokens: 3000));
      cubit.doEvent(const SendChatMessageEvent('Hello coach'));

      await Future<void>.delayed(Duration.zero);
      expect(events.isNotEmpty, isTrue);
      expect(events.first, isA<DisplayError>());
      expect(
        (events.first as DisplayError).errorMsg,
        contains('3000-token limit'),
      );

      await sub.cancel();
    });

    test(
      'streaming failure falls back gracefully to SendMessageUseCase',
      () async {
        when(
          mockStream(
            message: anyNamed('message'),
            sessionId: anyNamed('sessionId'),
          ),
        ).thenAnswer(
          (_) =>
              Stream<ChatMessageEntity>.error(Exception('Stream disconnected')),
        );

        final fallbackEntity = ChatMessageEntity(
          id: 'fallback_1',
          role: 'assistant',
          content: 'Fallback response from SendMessage',
          timestamp: DateTime(2026),
        );

        when(
          mockSendMessage(
            message: anyNamed('message'),
            sessionId: anyNamed('sessionId'),
          ),
        ).thenAnswer((_) async => Success(fallbackEntity));

        cubit.doEvent(const SendChatMessageEvent('Should fallback'));
        await Future<void>.delayed(const Duration(milliseconds: 50));

        expect(
          cubit.state.messages.any(
            (m) => m.content == 'Fallback response from SendMessage',
          ),
          isTrue,
        );
        verify(
          mockSendMessage(
            message: 'Should fallback',
            sessionId: anyNamed('sessionId'),
          ),
        ).called(1);
      },
    );

    test(
      'LoadChatHistoryEvent updates isHistoryLoading transition states',
      () async {
        when(mockGetHistory(sessionId: anyNamed('sessionId'))).thenAnswer((
          _,
        ) async {
          await Future<void>.delayed(const Duration(milliseconds: 10));
          return const Success([]);
        });

        cubit.doEvent(const LoadChatHistoryEvent(sessionId: 'session_target'));
        expect(cubit.state.isHistoryLoading, isTrue);

        await Future<void>.delayed(const Duration(milliseconds: 30));
        expect(cubit.state.isHistoryLoading, isFalse);
      },
    );
  });
}
