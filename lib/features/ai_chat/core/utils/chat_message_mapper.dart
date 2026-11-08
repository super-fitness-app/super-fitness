import 'package:super_fitness/features/ai_chat/data/models/chat_message_model.dart';
import 'package:super_fitness/features/ai_chat/data/models/structured_fitness_card_model.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/fitness_card_entity.dart';

abstract final class ChatMessageMapper {
  static ChatMessageEntity toEntity(ChatMessageModel model) => model.toEntity();
  static ChatMessageModel toModel(ChatMessageEntity entity) =>
      ChatMessageModel.fromEntity(entity);
  static List<ChatMessageEntity> toEntityList(List<ChatMessageModel> models) =>
      models.map(toEntity).toList();
  static List<ChatMessageModel> toModelList(List<ChatMessageEntity> entities) =>
      entities.map(toModel).toList();
}

extension ChatMessageModelMapper on ChatMessageModel {
  ChatMessageEntity toDomain() => toEntity();
}

extension StructuredFitnessCardModelMapper on StructuredFitnessCardModel {
  FitnessCardEntity toDomain() => toEntity();
}

extension ChatMessageEntityMapper on ChatMessageEntity {
  ChatMessageModel toModel() => ChatMessageModel.fromEntity(this);
}
