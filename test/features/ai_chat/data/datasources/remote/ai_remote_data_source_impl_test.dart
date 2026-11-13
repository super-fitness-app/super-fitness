// ignore_for_file: subtype_of_sealed_class, must_be_immutable

import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:super_fitness/config/session/session_service.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/contract/fitness_local_data_source.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/remote/ai_remote_data_source_impl.dart';

class MockDio extends Mock implements Dio {
  @override
  Future<Response<T>> post<T>(
    dynamic path, {
    dynamic data,
    dynamic queryParameters,
    dynamic options,
    dynamic cancelToken,
    dynamic onSendProgress,
    dynamic onReceiveProgress,
  }) =>
      super.noSuchMethod(
        Invocation.method(#post, [
          path,
        ], {
          #data: data,
          #queryParameters: queryParameters,
          #options: options,
          #cancelToken: cancelToken,
          #onSendProgress: onSendProgress,
          #onReceiveProgress: onReceiveProgress,
        }),
        returnValue: Future.value(
          Response<T>(
            requestOptions: RequestOptions(path: path.toString()),
            statusCode: 200,
          ),
        ),
      ) as Future<Response<T>>;
}

class MockFirebaseFirestore extends Mock implements FirebaseFirestore {
  @override
  CollectionReference<Map<String, dynamic>> collection([dynamic collectionPath]) =>
      super.noSuchMethod(
        Invocation.method(#collection, [collectionPath]),
        returnValue: MockCollectionReference(),
      ) as CollectionReference<Map<String, dynamic>>;
}

class MockCollectionReference extends Mock
    implements CollectionReference<Map<String, dynamic>> {
  @override
  DocumentReference<Map<String, dynamic>> doc([dynamic path]) =>
      super.noSuchMethod(
        Invocation.method(#doc, [path]),
        returnValue: MockDocumentReference(),
      ) as DocumentReference<Map<String, dynamic>>;

  @override
  Future<DocumentReference<Map<String, dynamic>>> add([dynamic data]) =>
      super.noSuchMethod(
        Invocation.method(#add, [data]),
        returnValue: Future.value(MockDocumentReference()),
      ) as Future<DocumentReference<Map<String, dynamic>>>;

  @override
  Query<Map<String, dynamic>> orderBy(
    dynamic field, {
    dynamic descending = false,
  }) =>
      super.noSuchMethod(
        Invocation.method(#orderBy, [field], {#descending: descending}),
        returnValue: MockQuery(),
      ) as Query<Map<String, dynamic>>;
}

class MockDocumentReference extends Mock
    implements DocumentReference<Map<String, dynamic>> {
  @override
  String get id => 'mock_doc_id';

  @override
  CollectionReference<Map<String, dynamic>> collection([dynamic collectionPath]) =>
      super.noSuchMethod(
        Invocation.method(#collection, [collectionPath]),
        returnValue: MockCollectionReference(),
      ) as CollectionReference<Map<String, dynamic>>;

  @override
  Future<DocumentSnapshot<Map<String, dynamic>>> get([GetOptions? options]) =>
      super.noSuchMethod(
        Invocation.method(#get, [options]),
        returnValue: Future.value(MockDocumentSnapshot()),
      ) as Future<DocumentSnapshot<Map<String, dynamic>>>;

  @override
  Future<void> set(dynamic data, [dynamic options]) =>
      super.noSuchMethod(
        Invocation.method(#set, [data, options]),
        returnValue: Future.value(),
      ) as Future<void>;
}

class MockDocumentSnapshot extends Mock
    implements DocumentSnapshot<Map<String, dynamic>> {
  @override
  bool get exists => true;

  @override
  Map<String, dynamic>? data() => {};
}

class MockQuery extends Mock implements Query<Map<String, dynamic>> {
  @override
  Future<QuerySnapshot<Map<String, dynamic>>> get([GetOptions? options]) =>
      super.noSuchMethod(
        Invocation.method(#get, [options]),
        returnValue: Future.value(MockQuerySnapshot()),
      ) as Future<QuerySnapshot<Map<String, dynamic>>>;
}

class MockQuerySnapshot extends Mock
    implements QuerySnapshot<Map<String, dynamic>> {
  @override
  List<QueryDocumentSnapshot<Map<String, dynamic>>> get docs => [];
}

class MockFirebaseAuth extends Mock implements FirebaseAuth {
  @override
  User? get currentUser => null;
}

class MockSessionService extends Mock implements SessionService {
  @override
  Future<String> getUserData() => Future.value('');
}

class MockFitnessLocalDataSource extends Mock
    implements FitnessLocalDataSource {
  @override
  Future<Map<String, dynamic>> getExerciseDetails({
    required String exerciseName,
    String? targetMuscle,
  }) async {
    return {
      'card_type': 'exercise',
      'card_title': exerciseName,
      'card_subtitle': 'Compound lift',
      'badge': targetMuscle ?? 'Chest',
      'card_details': {'equipment': 'Barbell'},
      'card_items': ['Keep back straight'],
    };
  }

  @override
  Future<Map<String, dynamic>> getMealNutrition({
    required String mealName,
    String? goal,
  }) async {
    return {
      'card_type': 'meal',
      'card_title': mealName,
      'card_subtitle': 'High Protein',
      'badge': goal ?? 'Muscle Gain',
      'card_details': {'calories': '300 kcal'},
      'card_items': ['Serve grilled'],
    };
  }
}

void main() {
  late MockDio mockDio;
  late MockFirebaseFirestore mockFirestore;
  late MockFirebaseAuth mockAuth;
  late MockSessionService mockSessionService;
  late MockFitnessLocalDataSource mockLocalDb;
  late AiRemoteDataSourceImpl remoteDataSource;
  late MockCollectionReference mockCollectionRef;
  late MockDocumentReference mockDocRef;

  setUp(() {
    mockDio = MockDio();
    mockFirestore = MockFirebaseFirestore();
    mockAuth = MockFirebaseAuth();
    mockSessionService = MockSessionService();
    mockLocalDb = MockFitnessLocalDataSource();
    mockCollectionRef = MockCollectionReference();
    mockDocRef = MockDocumentReference();

    when(mockFirestore.collection(any)).thenReturn(mockCollectionRef);
    when(mockCollectionRef.doc(any)).thenReturn(mockDocRef);
    when(mockDocRef.collection(any)).thenReturn(mockCollectionRef);
    when(mockDocRef.get()).thenAnswer((_) async => MockDocumentSnapshot());
    when(mockDocRef.set(any, any)).thenAnswer((_) async {});
    when(mockCollectionRef.add(any)).thenAnswer((_) async => mockDocRef);
    when(mockCollectionRef.orderBy(any, descending: anyNamed('descending')))
        .thenReturn(MockQuery());

    remoteDataSource = AiRemoteDataSourceImpl(
      dio: mockDio,
      sessionService: mockSessionService,
      localDbDataSource: mockLocalDb,
      firestore: mockFirestore,
      firebaseAuth: mockAuth,
    );
  });

  group('AiRemoteDataSourceImpl Tests', () {
    test('sendMessage triggers offline fallback harness when Dio throws timeout error', () async {
      when(
        mockDio.post(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/chat'),
          type: DioExceptionType.receiveTimeout,
        ),
      );

      final result = await remoteDataSource.sendMessage(
        message: 'How do I do a bench press?',
        sessionId: 'test_session',
      );

      expect(result.role, equals('assistant'));
      expect(result.content, contains('exercise database'));
      expect(result.fitnessCard, isNotNull);
      expect(result.fitnessCard!.title, equals('bench press'));
    });

    test('offline fallback routes keywords correctly', () async {
      when(
        mockDio.post(any, data: anyNamed('data'), options: anyNamed('options')),
      ).thenThrow(
        DioException(
          requestOptions: RequestOptions(path: '/api/chat'),
          type: DioExceptionType.connectionError,
        ),
      );

      // Meal routing
      final mealResult = await remoteDataSource.sendMessage(
        message: 'Give me a healthy chicken recipe for 200 calories',
        sessionId: 'test_session',
      );
      expect(mealResult.content, contains('nutritional breakdown'));
      expect(mealResult.fitnessCard, isNotNull);
      expect(mealResult.fitnessCard!.title, equals('chicken'));

      // Generic routing
      final genericResult = await remoteDataSource.sendMessage(
        message: 'Hello there',
        sessionId: 'test_session',
      );
      expect(genericResult.content, contains('I am your Smart Coach'));
      expect(genericResult.fitnessCard, isNull);
    });

    test('streamMessage yields streaming chunks from NDJSON response stream', () async {
      final ndjsonLines = [
        jsonEncode({
          'message': {'content': 'Strength '},
          'done': false,
        }),
        jsonEncode({
          'message': {'content': 'training rules.'},
          'done': true,
        }),
      ].join('\n');

      final stream = Stream<Uint8List>.fromIterable([
        Uint8List.fromList(utf8.encode(ndjsonLines)),
      ]);

      final responseBody = ResponseBody(stream, 200);

      when(
        mockDio.post<ResponseBody>(
          any,
          data: anyNamed('data'),
          options: anyNamed('options'),
        ),
      ).thenAnswer(
        (_) async => Response<ResponseBody>(
          data: responseBody,
          requestOptions: RequestOptions(path: '/api/chat'),
          statusCode: 200,
        ),
      );

      final chunks = await remoteDataSource.streamMessage(
        message: 'Hello',
        sessionId: 'test_session',
      ).toList();

      expect(chunks.isNotEmpty, isTrue);
      expect(chunks.last.content, equals('Strength training rules.'));
    });
  });
}
