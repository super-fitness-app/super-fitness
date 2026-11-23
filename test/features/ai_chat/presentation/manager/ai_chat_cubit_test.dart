// ignore_for_file: invalid_use_of_protected_member, invalid_use_of_visible_for_testing_member

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_session_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/exercise_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/ingredient_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/meal_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/meal_step_entity.dart';
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
  Future<ApiResults<ChatSessionEntity>> createNewSession({
    String? title,
  }) async {
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

  @override
  Future<List<MealEntity>> searchMeals({
    String? query,
    double? minCalories,
    double? maxCalories,
    double? minProtein,
  }) async => [];

  @override
  Future<MealEntity?> getMealById(String id) async => null;

  @override
  Future<List<IngredientEntity>> getMealIngredients(String mealId) async => [];

  @override
  Future<List<MealStepEntity>> getMealSteps(String mealId) async => [];

  @override
  Future<List<ExerciseEntity>> searchExercises({
    String? query,
    String? muscleGroup,
    String? difficulty,
    String? equipment,
  }) async => [];

  @override
  Future<ExerciseEntity?> getExerciseById(String id) async => null;
}

class FakeSessionService extends Fake implements SessionService {
  String userData = '{"firstName": "Ahmed"}';

  @override
  Future<String> getUserData() async => userData;
}

class FakeFirebaseAuth extends Fake implements FirebaseAuth {
  User? mockCurrentUser;

  @override
  User? get currentUser => mockCurrentUser;
}

void main() {
  late FakeChatRepository fakeRepo;
  late SendMessageUseCase sendMessageUseCase;
  late StreamMessageUseCase streamMessageUseCase;
  late GetChatHistoryUseCase getChatHistoryUseCase;
  late ClearChatUseCase clearChatUseCase;
  late FakeSessionService fakeSessionService;
  late FakeFirebaseAuth fakeFirebaseAuth;
  late GetChatSessionsUseCase getChatSessionsUseCase;
  late CreateNewSessionUseCase createNewSessionUseCase;
  late DeleteSessionUseCase deleteSessionUseCase;
  late AiChatCubit cubit;

  setUp(() {
    fakeRepo = FakeChatRepository();
    sendMessageUseCase = SendMessageUseCase(fakeRepo);
    streamMessageUseCase = StreamMessageUseCase(fakeRepo);
    getChatHistoryUseCase = GetChatHistoryUseCase(fakeRepo);
    clearChatUseCase = ClearChatUseCase(fakeRepo);
    fakeSessionService = FakeSessionService();
    fakeFirebaseAuth = FakeFirebaseAuth();
    getChatSessionsUseCase = GetChatSessionsUseCase(fakeRepo);
    createNewSessionUseCase = CreateNewSessionUseCase(fakeRepo);
    deleteSessionUseCase = DeleteSessionUseCase(fakeRepo);

    cubit = AiChatCubit(
      sendMessageUseCase,
      getChatHistoryUseCase,
      clearChatUseCase,
      fakeSessionService,
      fakeFirebaseAuth,
      streamMessageUseCase,
      getChatSessionsUseCase,
      createNewSessionUseCase,
      deleteSessionUseCase,
    );
  });

  tearDown(() async {
    await cubit.close();
  });

  group('AiChatCubit State Management Tests', () {
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

    test(
      'SendChatMessageEvent should stream chunks progressively into messages',
      () async {
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
      },
    );

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

    test(
      'CreateNewSessionEvent creates session and prepends to list',
      () async {
        cubit.doEvent(const CreateNewSessionEvent(title: 'Leg Day'));
        await pumpEventQueue();

        expect(cubit.state.sessions.length, equals(1));
        expect(cubit.state.currentSessionId, equals('test_session'));
      },
    );

    test(
      'DeleteChatSessionEvent removes session from state and switches active',
      () async {
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
        cubit.emit(cubit.state.copyWith(sessions: [session1, session2]));
        cubit.doEvent(const SelectChatSessionEvent('s_active'));
        await pumpEventQueue();

        cubit.doEvent(const DeleteChatSessionEvent('s_active'));
        await pumpEventQueue();

        expect(cubit.state.sessions.length, equals(1));
        expect(cubit.state.sessions.first.id, equals('s_next'));
        expect(cubit.state.currentSessionId, equals('s_next'));
      },
    );

    test(
      'SendChatMessageEvent dynamically formats session title from first user message',
      () async {
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

        cubit.doEvent(
          const SendChatMessageEvent(
            'what is the best chest exercise for hypertrophy?',
          ),
        );
        await pumpEventQueue();

        expect(
          cubit.state.sessions.first.title.startsWith('What is the best chest'),
          isTrue,
        );
      },
    );

    test(
      'SendChatMessageEvent is ignored when session is locked (>=3000 tokens)',
      () async {
        cubit.emit(cubit.state.copyWith(currentSessionTokens: 3000));

        cubit.doEvent(const SendChatMessageEvent('Should be blocked'));
        await pumpEventQueue();

        expect(cubit.state.messages, isEmpty);
        expect(cubit.state.isSessionLocked, isTrue);
      },
    );

    test(
      'SelectChatSessionEvent sets isHistoryLoading to true then false after history loads',
      () async {
        fakeRepo.historyToReturn = [testMsg];
        cubit.doEvent(const SelectChatSessionEvent('session_test'));
        expect(cubit.state.isHistoryLoading, isTrue);
        expect(cubit.state.messages, isEmpty);

        await pumpEventQueue();

        expect(cubit.state.isHistoryLoading, isFalse);
        expect(cubit.state.messages, equals([testMsg]));
      },
    );
  });
}
