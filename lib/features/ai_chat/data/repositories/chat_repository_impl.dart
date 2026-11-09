import 'package:injectable/injectable.dart';
import 'package:super_fitness/config/network/api_results.dart';
import 'package:super_fitness/features/ai_chat/core/errors/ai_chat_exception.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/contract/ai_remote_data_source.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_session_entity.dart';
import 'package:super_fitness/features/ai_chat/data/datasources/local/fitness_local_data_source.dart';
import 'package:super_fitness/features/ai_chat/domain/repositories/chat_repository.dart';

import '../../domain/entities/exercise_entity.dart';
import '../../domain/entities/ingredient_entity.dart';
import '../../domain/entities/meal_entity.dart';
import '../../domain/entities/meal_step_entity.dart';

@LazySingleton(as: ChatRepository)
class ChatRepositoryImpl implements ChatRepository {
  final FitnessLocalDataSource localDataSource;
  final AiRemoteDataSource _remoteDataSource;
  ChatRepositoryImpl(this.localDataSource, this._remoteDataSource);

  @override
  Future<List<MealEntity>> searchMeals({
    String? query,
    double? minCalories,
    double? maxCalories,
    double? minProtein,
  }) async {
    final models = await localDataSource.searchMeals(
      query: query,
      minCalories: minCalories,
      maxCalories: maxCalories,
      minProtein: minProtein,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<MealEntity?> getMealById(String id) async {
    final model = await localDataSource.getMealById(id);

    return model?.toEntity();
  }

  @override
  Future<List<IngredientEntity>> getMealIngredients(String mealId) async {
    final models = await localDataSource.getMealIngredients(mealId);

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ApiResults<ChatMessageEntity>> sendMessage({
    required String message,
    String sessionId = 'default_session',
  }) async {
    try {
      final model = await _remoteDataSource.sendMessage(
        message: message,
        sessionId: sessionId,
      );
      return Success(model.toEntity());
    } on AiChatException catch (e) {
      return FailureResponse(AiChatFailure(e.message));
    } catch (e) {
      return FailureResponse(ServerMessageFailure(e.toString()));
    }
  }

  @override
  Stream<ChatMessageEntity> streamMessage({
    required String message,
    String sessionId = 'default_session',
  }) {
    return _remoteDataSource
        .streamMessage(message: message, sessionId: sessionId)
        .map((model) => model.toEntity());
  }

  @override
  Future<ApiResults<List<ChatMessageEntity>>> getChatHistory({
    String sessionId = 'default_session',
  }) async {
    try {
      final models = await _remoteDataSource.getChatHistory(
        sessionId: sessionId,
      );
      return Success(models.map((m) => m.toEntity()).toList());
    } on AiChatException catch (e) {
      return FailureResponse(AiChatFailure(e.message));
    } catch (e) {
      return FailureResponse(ServerMessageFailure(e.toString()));
    }
  }

  @override
  Future<ApiResults<void>> clearChatHistory({
    String sessionId = 'default_session',
  }) async {
    try {
      await _remoteDataSource.clearChatHistory(sessionId: sessionId);
      return const Success(null);
    } on AiChatException catch (e) {
      return FailureResponse(AiChatFailure(e.message));
    } catch (e) {
      return FailureResponse(ServerMessageFailure(e.toString()));
    }
  }

  @override
  Future<List<MealStepEntity>> getMealSteps(String mealId) async {
    final models = await localDataSource.getMealSteps(mealId);

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ApiResults<List<ChatSessionEntity>>> getChatSessions() async {
    try {
      final models = await _remoteDataSource.getChatSessions();
      return Success(models.map((m) => m.toEntity()).toList());
    } on AiChatException catch (e) {
      return FailureResponse(AiChatFailure(e.message));
    } catch (e) {
      return FailureResponse(ServerMessageFailure(e.toString()));
    }
  }

  @override
  Future<ApiResults<ChatSessionEntity>> createNewSession({
    String? title,
  }) async {
    try {
      final model = await _remoteDataSource.createNewSession(title: title);
      return Success(model.toEntity());
    } on AiChatException catch (e) {
      return FailureResponse(AiChatFailure(e.message));
    } catch (e) {
      return FailureResponse(ServerMessageFailure(e.toString()));
    }
  }

  @override
  Future<List<ExerciseEntity>> searchExercises({
    String? query,
    String? muscleGroup,
    String? difficulty,
    String? equipment,
  }) async {
    final models = await localDataSource.searchExercises(
      query: query,
      muscleGroup: muscleGroup,
      difficulty: difficulty,
      equipment: equipment,
    );

    return models.map((model) => model.toEntity()).toList();
  }

  @override
  Future<ApiResults<void>> deleteSession(String sessionId) async {
    try {
      await _remoteDataSource.deleteSession(sessionId);
      return const Success(null);
    } on AiChatException catch (e) {
      return FailureResponse(AiChatFailure(e.message));
    } catch (e) {
      return FailureResponse(ServerMessageFailure(e.toString()));
    }
  }

  @override
  Future<ExerciseEntity?> getExerciseById(String id) async {
    final model = await localDataSource.getExerciseById(id);

    return model?.toEntity();
  }
}
