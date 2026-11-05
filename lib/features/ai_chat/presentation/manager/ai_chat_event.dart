sealed class AiChatEvent {
  const AiChatEvent();
}

final class LoadChatHistoryEvent extends AiChatEvent {
  const LoadChatHistoryEvent();
}

final class SendChatMessageEvent extends AiChatEvent {
  final String message;
  const SendChatMessageEvent(this.message);
}

final class ClearChatHistoryEvent extends AiChatEvent {
  const ClearChatHistoryEvent();
}
