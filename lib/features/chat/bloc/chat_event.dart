
part of 'chat_detail_bloc.dart';

abstract class ChatDetailEvent extends Equatable {
  const ChatDetailEvent();
  @override
  List<Object?> get props => [];
}

class ChatDetailFetchEvent extends ChatDetailEvent {
  final String conversationId;
  const ChatDetailFetchEvent(this.conversationId);
  @override
  List<Object?> get props => [conversationId];
}

class ChatDetailMessageChangedEvent extends ChatDetailEvent {
  final String text;
  const ChatDetailMessageChangedEvent(this.text);
  @override
  List<Object?> get props => [text];
}

class ChatDetailSendEvent extends ChatDetailEvent {
  const ChatDetailSendEvent();
}

class ChatDetailReplySetEvent extends ChatDetailEvent {
  final ChatMessage message;
  const ChatDetailReplySetEvent(this.message);
  @override
  List<Object?> get props => [message.id];
}

class ChatDetailReplyClearedEvent extends ChatDetailEvent {
  const ChatDetailReplyClearedEvent();
}