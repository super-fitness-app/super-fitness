// ignore_for_file: unused_field

import 'package:injectable/injectable.dart';
import 'package:super_fitness/features/ai_chat/data/database/fitness_database_manager.dart';
import 'package:super_fitness/features/ai_chat/data/models/chat_message_model.dart';

abstract interface class FitnessLocalDataSource {
  Future<List<ChatMessageModel>> getCachedMessages();
  Future<void> saveMessage(ChatMessageModel message);
  Future<void> clearMessages();
}

@LazySingleton(as: FitnessLocalDataSource)
class FitnessLocalDataSourceImpl implements FitnessLocalDataSource {
  final FitnessDatabaseManager _databaseManager;

  const FitnessLocalDataSourceImpl(this._databaseManager);

  @override
  Future<List<ChatMessageModel>> getCachedMessages() async {
    return [];
  }

  @override
  Future<void> saveMessage(ChatMessageModel message) async {}

  @override
  Future<void> clearMessages() async {}
}
