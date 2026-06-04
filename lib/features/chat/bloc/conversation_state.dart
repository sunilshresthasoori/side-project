part of 'conversation_bloc.dart';

abstract class ConversationsState extends Equatable {
  const ConversationsState();
  @override
  List<Object?> get props => [];
}

class ConversationsInitial extends ConversationsState {
  const ConversationsInitial();
}

class ConversationsLoading extends ConversationsState {
  const ConversationsLoading();
}

class ConversationsLoaded extends ConversationsState {
  final List<Conversation> all;
  final List<Conversation> filtered;
  final String searchQuery;

  const ConversationsLoaded({
    required this.all,
    required this.filtered,
    this.searchQuery = '',
  });

  ConversationsLoaded copyWith({
    List<Conversation>? all,
    List<Conversation>? filtered,
    String? searchQuery,
  }) =>
      ConversationsLoaded(
        all: all ?? this.all,
        filtered: filtered ?? this.filtered,
        searchQuery: searchQuery ?? this.searchQuery,
      );

  @override
  List<Object?> get props => [all, filtered, searchQuery];
}

class ConversationsError extends ConversationsState {
  final String message;
  const ConversationsError(this.message);
  @override
  List<Object?> get props => [message];
}
