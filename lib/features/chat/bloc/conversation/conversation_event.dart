
part of 'conversations_bloc.dart';

abstract class ConversationsEvent extends Equatable {
  const ConversationsEvent();
  @override
  List<Object?> get props => [];
}

class ConversationsFetchEvent extends ConversationsEvent {
  const ConversationsFetchEvent();
}

class ConversationsSearchChangedEvent extends ConversationsEvent {
  final String query;
  const ConversationsSearchChangedEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class ConversationMutedEvent extends ConversationsEvent {
  final String conversationId;
  const ConversationMutedEvent(this.conversationId);
  @override
  List<Object?> get props => [conversationId];
}

class ConversationPinnedEvent extends ConversationsEvent {
  final String conversationId;
  const ConversationPinnedEvent(this.conversationId);
  @override
  List<Object?> get props => [conversationId];
}