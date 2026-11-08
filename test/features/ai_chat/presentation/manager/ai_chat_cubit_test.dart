import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_session_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/clear_chat_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/create_new_session_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/delete_session_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/get_chat_history_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/get_chat_sessions_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/send_message_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/stream_message_use_case.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_cubit.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_event.dart';

class FakeChatRepository implements ChatRepository {
  ChatMessageEntity? messageToReturn;
  List<ChatMessageEntity> streamTokensToReturn = [];
  List<ChatMessageEntity> historyToReturn = [];
  List<ChatSessionEntity> sessionsToReturn = [];
  ChatSessionEntity? createdSessionToReturn;
  String? capturedSentMessage;
  String? capturedSessionId;

  @override
  Future<ApiResults<ChatMessageEntity>> sendMessage({
    required String message,
    String sessionId = 'default_session',
  }) async {
    capturedSentMessage = message;
    capturedSessionId = sessionId;
    return Success(messageToReturn!);
  }

  @override
  Stream<ChatMessageEntity> streamMessage({
    required String message,
    String sessionId = 'default_session',
  }) async* {
    capturedSentMessage = message;
    capturedSessionId = sessionId;
    if (streamTokensToReturn.isNotEmpty) {
      for (final item in streamTokensToReturn) {
        yield item;
      }
    } else if (messageToReturn != null) {
      yield messageToReturn!;
    }
  }

  @override
  Future<ApiResults<List<ChatMessageEntity>>> getChatHistory({
    String sessionId = 'default_session',
  }) async {
    capturedSessionId = sessionId;
    return Success(historyToReturn);
  }

  @override
  Future<ApiResults<void>> clearChatHistory({
    String sessionId = 'default_session',
  }) async {
    capturedSessionId = sessionId;
    return const Success(null);
  }

  @override
  Future<ApiResults<List<ChatSessionEntity>>> getChatSessions() async {
    return Success(sessionsToReturn);
  }

  @override
  Future<ApiResults<ChatSessionEntity>> createNewSession({String? title}) async {
    return Success(
      createdSessionToReturn ??
          ChatSessionEntity(
            id: 'test_session',
            title: title ?? 'New Session',
            createdAt: DateTime(2026),
            updatedAt: DateTime(2026),
          ),
    );
  }

  @override
  Future<ApiResults<void>> deleteSession(String sessionId) async {
    capturedSessionId = sessionId;
    return const Success(null);
  }
}

class MockSessionService extends Mock implements SessionService {
  @override
  Future<String> getUserData() =>
      super.noSuchMethod(
        Invocation.method(#getUserData, []),
        returnValue: Future.value('{"firstName": "Ahmed"}'),
      ) as Future<String>;
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {}

void main() {
  late FakeChatRepository fakeRepo;
  late SendMessageUseCase sendMessageUseCase;
  late StreamMessageUseCase streamMessageUseCase;
  late GetChatHistoryUseCase getChatHistoryUseCase;
  late ClearChatUseCase clearChatUseCase;
  late MockSessionService mockSessionService;
  late MockFirebaseAuth mockFirebaseAuth;
  late AiChatCubit cubit;

  setUp(() {
    fakeRepo = FakeChatRepository();
    sendMessageUseCase = SendMessageUseCase(fakeRepo);
    streamMessageUseCase = StreamMessageUseCase(fakeRepo);
    getChatHistoryUseCase = GetChatHistoryUseCase(fakeRepo);
    clearChatUseCase = ClearChatUseCase(fakeRepo);
    mockSessionService = MockSessionService();
    mockFirebaseAuth = MockFirebaseAuth();

    when(mockSessionService.getUserData())
        .thenAnswer((_) async => '{"firstName": "Ahmed"}');

    final getChatSessionsUseCase = GetChatSessionsUseCase(fakeRepo);
    final createNewSessionUseCase = CreateNewSessionUseCase(fakeRepo);
    final deleteSessionUseCase = DeleteSessionUseCase(fakeRepo);

    cubit = AiChatCubit(
      sendMessageUseCase,
      getChatHistoryUseCase,
      clearChatUseCase,
      mockSessionService,
      mockFirebaseAuth,
      streamMessageUseCase,
      getChatSessionsUseCase,
      createNewSessionUseCase,
      deleteSessionUseCase,
    );
  });

  tearDown(() {
    cubit.close();
  });

  group('AiChatCubit', () {
    final testMsg = ChatMessageEntity(
      id: '1',
      role: 'assistant',
      content: 'Hello Athlete',
      timestamp: DateTime(2026),
    );

    test('initial state has empty messages and not typing', () {
      expect(cubit.state.messages, isEmpty);
      expect(cubit.state.isTyping, isFalse);
    });

    test('SendChatMessageEvent should stream chunks progressively into messages', () async {
      fakeRepo.streamTokensToReturn = [
        ChatMessageEntity(
          id: '10',
          role: 'assistant',
          content: 'Hello',
          timestamp: DateTime(2026),
        ),
        ChatMessageEntity(
          id: '10',
          role: 'assistant',
          content: 'Hello Athlete',
          timestamp: DateTime(2026),
        ),
      ];

      cubit.doEvent(const SendChatMessageEvent('Hi coach'));
      await pumpEventQueue();

      expect(cubit.state.messages.length, equals(2));
      expect(cubit.state.messages.first.content, equals('Hi coach'));
      expect(cubit.state.messages.last.content, equals('Hello Athlete'));
      expect(cubit.state.isTyping, isFalse);
    });

    test('LoadChatHistoryEvent loads messages successfully', () async {
      fakeRepo.historyToReturn = [testMsg];

      cubit.doEvent(const LoadChatHistoryEvent());
      await pumpEventQueue();

      expect(cubit.state.messages.length, equals(1));
      expect(cubit.state.messages.first, equals(testMsg));
    });

    test('ClearChatHistoryEvent clears message state', () async {
      cubit.doEvent(const ClearChatHistoryEvent());
      await pumpEventQueue();

      expect(cubit.state.messages, isEmpty);
    });

    test('LoadChatSessionsEvent loads sessions into state', () async {
      final session = ChatSessionEntity(
        id: 's1',
        title: 'Workout Advice',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
        totalTokens: 150,
      );
      fakeRepo.sessionsToReturn = [session];

      cubit.doEvent(const LoadChatSessionsEvent());
      await pumpEventQueue();

      expect(cubit.state.sessions.length, equals(1));
      expect(cubit.state.sessions.first.id, equals('s1'));
    });

    test('CreateNewSessionEvent creates session and prepends to list', () async {
      cubit.doEvent(const CreateNewSessionEvent(title: 'Leg Day'));
      await pumpEventQueue();

      expect(cubit.state.sessions.length, equals(1));
      expect(cubit.state.currentSessionId, equals('test_session'));
    });

    test('DeleteChatSessionEvent removes session from state and switches active', () async {
      final session1 = ChatSessionEntity(
        id: 's_active',
        title: 'Session 1',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      final session2 = ChatSessionEntity(
        id: 's_next',
        title: 'Session 2',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      cubit.emit(cubit.state.copyWith(
        sessions: [session1, session2],
      ));
      cubit.doEvent(const SelectChatSessionEvent('s_active'));
      await pumpEventQueue();

      cubit.doEvent(const DeleteChatSessionEvent('s_active'));
      await pumpEventQueue();

      expect(cubit.state.sessions.length, equals(1));
      expect(cubit.state.sessions.first.id, equals('s_next'));
      expect(cubit.state.currentSessionId, equals('s_next'));
    });

    test('SendChatMessageEvent dynamically formats session title from first user message', () async {
      final session = ChatSessionEntity(
        id: 's_dynamic',
        title: 'New Chat',
        createdAt: DateTime(2026),
        updatedAt: DateTime(2026),
      );
      fakeRepo.messageToReturn = testMsg;
      fakeRepo.sessionsToReturn = [session];
      cubit.emit(cubit.state.copyWith(sessions: [session]));
      cubit.doEvent(const SelectChatSessionEvent('s_dynamic'));
      await pumpEventQueue();

      cubit.doEvent(const SendChatMessageEvent('what is the best chest exercise for hypertrophy?'));
      await pumpEventQueue();

      expect(cubit.state.sessions.first.title.startsWith('What is the best chest'), isTrue);
    });

    test('SendChatMessageEvent is ignored when session is locked (>=3000 tokens)', () async {
      cubit.emit(cubit.state.copyWith(currentSessionTokens: 3200));

      cubit.doEvent(const SendChatMessageEvent('Should be blocked'));
      await pumpEventQueue();

      expect(cubit.state.messages, isEmpty);
      expect(cubit.state.isSessionLocked, isTrue);
    });
  });
}
