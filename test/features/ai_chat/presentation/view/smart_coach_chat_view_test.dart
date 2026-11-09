// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/mockito.dart';
// import 'package:super_fitness/config/l10n/app_localizations.dart';
// import 'package:super_fitness/config/network/api_results.dart';
// import 'package:super_fitness/config/session/session_service.dart';
// import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
// import 'package:super_fitness/features/ai_chat/domain/entities/chat_session_entity.dart';
// import 'package:super_fitness/features/ai_chat/domain/entities/fitness_card_entity.dart';
// import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';
// import 'package:super_fitness/features/ai_chat/domain/use_cases/clear_chat_use_case.dart';
// import 'package:super_fitness/features/ai_chat/domain/use_cases/get_chat_history_use_case.dart';
// import 'package:super_fitness/features/ai_chat/domain/use_cases/send_message_use_case.dart';
// import 'package:super_fitness/features/ai_chat/presentation/manager/ai_chat_cubit.dart';
// import 'package:super_fitness/features/ai_chat/presentation/view/smart_coach_chat_view.dart';
// import 'package:super_fitness/features/ai_chat/presentation/view/widgets/empty_chat_placeholder.dart';
// import 'package:super_fitness/features/ai_chat/presentation/view/widgets/fitness_card_widget.dart';

// class FakeChatRepository implements ChatRepository {
//   ChatMessageEntity? messageToReturn;
//   List<ChatMessageEntity> historyToReturn = [];

//   @override
//   Future<ApiResults<ChatMessageEntity>> sendMessage({
//     required String message,
//     String sessionId = 'default_session',
//   }) async {
//     return Success(messageToReturn!);
//   }

//   @override
//   Stream<ChatMessageEntity> streamMessage({
//     required String message,
//     String sessionId = 'default_session',
//   }) async* {
//     if (messageToReturn != null) {
//       yield messageToReturn!;
//     }
//   }

//   @override
//   Future<ApiResults<List<ChatMessageEntity>>> getChatHistory({
//     String sessionId = 'default_session',
//   }) async {
//     return Success(historyToReturn);
//   }

//   @override
//   Future<ApiResults<void>> clearChatHistory({
//     String sessionId = 'default_session',
//   }) async {
//     return const Success(null);
//   }

//   @override
//   Future<ApiResults<List<ChatSessionEntity>>> getChatSessions() async {
//     return const Success([]);
//   }

//   @override
//   Future<ApiResults<ChatSessionEntity>> createNewSession({
//     String? title,
//   }) async {
//     return Success(
//       ChatSessionEntity(
//         id: 'test_session',
//         title: title ?? 'New Session',
//         createdAt: DateTime(2026),
//         updatedAt: DateTime(2026),
//       ),
//     );
//   }

//   @override
//   Future<ApiResults<void>> deleteSession(String sessionId) async {
//     return const Success(null);
//   }
// }

// class MockSessionService extends Mock implements SessionService {
//   @override
//   Future<String> getUserData() =>
//       super.noSuchMethod(
//             Invocation.method(#getUserData, []),
//             returnValue: Future.value('{"firstName": "Ahmed"}'),
//           )
//           as Future<String>;
// }

// class MockFirebaseAuth extends Mock implements FirebaseAuth {}

// void main() {
//   late FakeChatRepository fakeRepo;
//   late SendMessageUseCase sendMessageUseCase;
//   late GetChatHistoryUseCase getChatHistoryUseCase;
//   late ClearChatUseCase clearChatUseCase;
//   late MockSessionService mockSession;
//   late MockFirebaseAuth mockFirebaseAuth;
//   late AiChatCubit cubit;

//   setUp(() {
//     fakeRepo = FakeChatRepository();
//     sendMessageUseCase = SendMessageUseCase(fakeRepo);
//     getChatHistoryUseCase = GetChatHistoryUseCase(fakeRepo);
//     clearChatUseCase = ClearChatUseCase(fakeRepo);
//     mockSession = MockSessionService();
//     mockFirebaseAuth = MockFirebaseAuth();

//     when(
//       mockSession.getUserData(),
//     ).thenAnswer((_) async => '{"firstName": "Ahmed"}');

//     cubit = AiChatCubit(
//       sendMessageUseCase,
//       getChatHistoryUseCase,
//       clearChatUseCase,
//       mockSession,
//       mockFirebaseAuth,
//     );
//   });

//   tearDown(() {
//     cubit.close();
//   });

//   Widget buildTestWidget() {
//     return MaterialApp(
//       localizationsDelegates: const [
//         AppLocalizations.delegate,
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//       supportedLocales: AppLocalizations.supportedLocales,
//       home: SmartCoachChatView(cubit: cubit),
//     );
//   }

//   group('SmartCoachChatView', () {
//     testWidgets('renders EmptyChatPlaceholder when messages are empty', (
//       tester,
//     ) async {
//       fakeRepo.historyToReturn = [];

//       await tester.pumpWidget(buildTestWidget());
//       await tester.pumpAndSettle();

//       expect(find.byType(EmptyChatPlaceholder), findsOneWidget);
//       expect(find.text('How can I help you today?'), findsOneWidget);
//     });

//     testWidgets('renders top bar with title and input field', (tester) async {
//       await tester.pumpWidget(buildTestWidget());
//       await tester.pump();

//       expect(find.byType(TextField), findsOneWidget);
//       expect(find.byIcon(Icons.send_rounded), findsOneWidget);
//     });

//     testWidgets('renders messages and structured fitness card', (tester) async {
//       final cardMsg = ChatMessageEntity(
//         id: '1',
//         role: 'assistant',
//         content: 'Check this exercise:',
//         timestamp: DateTime(2026),
//         fitnessCard: const FitnessCardEntity(
//           cardType: FitnessCardType.exercise,
//           title: 'Barbell Bench Press',
//           metrics: {'Sets': '4x8'},
//         ),
//       );

//       fakeRepo.historyToReturn = [cardMsg];

//       await tester.pumpWidget(buildTestWidget());
//       await tester.pumpAndSettle();

//       expect(find.text('Check this exercise:'), findsOneWidget);
//       expect(find.byType(FitnessCardWidget), findsOneWidget);
//       expect(find.text('Barbell Bench Press'), findsOneWidget);
//     });
//   });
// }
