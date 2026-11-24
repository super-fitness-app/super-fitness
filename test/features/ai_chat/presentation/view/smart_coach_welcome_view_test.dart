import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/config/l10n/app_localizations.dart';
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
import 'package:super_fitness/features/ai_chat/domain/use_cases/get_chat_history_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/get_chat_sessions_use_case.dart';
import 'package:super_fitness/features/ai_chat/domain/use_cases/send_message_use_case.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_cubit.dart';
import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_event.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/smart_coach_welcome_view.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/welcome_glass_card.dart';
import 'package:super_fitness/features/ai_chat/presentation/view/widgets/welcome_top_bar.dart';

class _FakeChatRepo implements ChatRepository {
  @override
  Future<ApiResults<List<ChatSessionEntity>>> getChatSessions() async =>
      const Success([]);

  @override
  Future<ApiResults<ChatMessageEntity>> sendMessage({
    required String message,
    String sessionId = 'default_session',
  }) async => throw UnimplementedError();

  @override
  Stream<ChatMessageEntity> streamMessage({
    required String message,
    String sessionId = 'default_session',
  }) async* {}

  @override
  Future<ApiResults<List<ChatMessageEntity>>> getChatHistory({
    String sessionId = 'default_session',
  }) async => const Success([]);

  @override
  Future<ApiResults<void>> clearChatHistory({
    String sessionId = 'default_session',
  }) async => const Success(null);

  @override
  Future<ApiResults<ChatSessionEntity>> createNewSession({
    String? title,
  }) async => throw UnimplementedError();

  @override
  Future<ApiResults<void>> deleteSession(String sessionId) async =>
      const Success(null);

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

class _FakeSessionService extends Mock implements SessionService {
  @override
  Future<String> getUserData() => Future.value('{"firstName": "Athlete"}');
}

class _FakeFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  User? get currentUser => null;
}

class _SpyAiChatCubit extends AiChatCubit {
  final List<Object> receivedEvents = [];

  _SpyAiChatCubit({
    required SendMessageUseCase sendMessageUseCase,
    required GetChatHistoryUseCase getChatHistoryUseCase,
    required ClearChatUseCase clearChatUseCase,
    required SessionService sessionService,
    required FirebaseAuth firebaseAuth,
    GetChatSessionsUseCase? getChatSessionsUseCase,
  }) : super(
         sendMessageUseCase,
         getChatHistoryUseCase,
         clearChatUseCase,
         sessionService,
         firebaseAuth,
         null,
         getChatSessionsUseCase,
       );

  @override
  void doEvent(Object event) {
    receivedEvents.add(event);
    super.doEvent(event);
  }
}

void main() {
  Widget buildTestableWidget({Widget? child}) {
    return MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en'), Locale('ar')],
      home: child ?? const SmartCoachWelcomeView(),
    );
  }

  group('SmartCoachWelcomeView Widget Tests', () {
    testWidgets(
      'renders top bar, robot graphic, and glass card without crashing',
      (tester) async {
        await tester.pumpWidget(buildTestableWidget());
        await tester.pumpAndSettle();

        expect(find.byType(WelcomeTopBar), findsOneWidget);
        expect(find.byType(WelcomeGlassCard), findsOneWidget);
        expect(find.text('Get Started'), findsOneWidget);
        expect(find.text('I Am Your Smart Coach'), findsOneWidget);
      },
    );

    testWidgets('WelcomeGlassCard triggers onGetStarted callback on tap', (
      tester,
    ) async {
      var tapped = false;
      await tester.pumpWidget(
        buildTestableWidget(
          child: Scaffold(
            body: WelcomeGlassCard(
              onGetStarted: () {
                tapped = true;
              },
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final buttonFinder = find.widgetWithText(ElevatedButton, 'Get Started');
      expect(buttonFinder, findsOneWidget);

      await tester.tap(buttonFinder);
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('dispatches LoadChatSessionsEvent on initial mount', (
      tester,
    ) async {
      final fakeRepo = _FakeChatRepo();
      final cubit = _SpyAiChatCubit(
        sendMessageUseCase: SendMessageUseCase(fakeRepo),
        getChatHistoryUseCase: GetChatHistoryUseCase(fakeRepo),
        clearChatUseCase: ClearChatUseCase(fakeRepo),
        sessionService: _FakeSessionService(),
        firebaseAuth: _FakeFirebaseAuth(),
        getChatSessionsUseCase: GetChatSessionsUseCase(fakeRepo),
      );

      await tester.pumpWidget(
        buildTestableWidget(child: SmartCoachWelcomeView(cubit: cubit)),
      );
      await tester.pumpAndSettle();

      expect(
        cubit.receivedEvents.any((e) => e is LoadChatSessionsEvent),
        isTrue,
      );
      await cubit.close();
    });
  });
}
