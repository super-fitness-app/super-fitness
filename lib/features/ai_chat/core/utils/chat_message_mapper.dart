import 'package:super_fitness/features/ai_chat/data/models/chat_message_model.dart';
import 'package:super_fitness/features/ai_chat/domain/entities/chat_message_entity.dart';

abstract final class ChatMessageMapper {
  static ChatMessageEntity toEntity(ChatMessageModel model) {
    return model.toEntity();
  }

  static ChatMessageModel toModel(ChatMessageEntity entity) {
    return ChatMessageModel.fromEntity(entity);
  }

  static List<ChatMessageEntity> toEntityList(List<ChatMessageModel> models) {
    return models.map(toEntity).toList();
  }

  static List<ChatMessageModel> toModelList(List<ChatMessageEntity> entities) {
    return entities.map(toModel).toList();
  }
}
