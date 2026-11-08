sealed class AiChatEvent {
  const AiChatEvent();
}

final class LoadChatHistoryEvent extends AiChatEvent {
  final String? sessionId;
  const LoadChatHistoryEvent({this.sessionId});
}

final class SendChatMessageEvent extends AiChatEvent {
  final String message;
  final String? sessionId;
  const SendChatMessageEvent(this.message, {this.sessionId});
}

final class ClearChatHistoryEvent extends AiChatEvent {
  final String? sessionId;
  const ClearChatHistoryEvent({this.sessionId});
}

final class LoadChatSessionsEvent extends AiChatEvent {
  const LoadChatSessionsEvent();
}

final class SelectChatSessionEvent extends AiChatEvent {
  final String sessionId;
  const SelectChatSessionEvent(this.sessionId);
}

final class CreateNewSessionEvent extends AiChatEvent {
  final String? title;
  const CreateNewSessionEvent({this.title});
}

final class DeleteChatSessionEvent extends AiChatEvent {
  final String sessionId;
  const DeleteChatSessionEvent(this.sessionId);
}
