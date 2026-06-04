
part of 'chat_detail_bloc.dart';

abstract class ChatDetailState extends Equatable {
  const ChatDetailState();

  @override
  List<Object?> get props => [];
}

class ChatDetailInitial extends ChatDetailState {
  const ChatDetailInitial();
}

class ChatDetailLoading extends ChatDetailState {
  const ChatDetailLoading();
}

class ChatDetailLoaded extends ChatDetailState {
  final String conversationId;
  final List<ChatMessage> messages;
  final String draftText;
  final bool isSending;
  final ChatMessage? replyToMessage;
  final String? sendError;

  const ChatDetailLoaded({
    required this.conversationId,
    required this.messages,
    required this.draftText,
    this.isSending = false,
    this.replyToMessage,
    this.sendError,
  });

  ChatDetailLoaded copyWith({
    String? conversationId,
    List<ChatMessage>? messages,
    String? draftText,
    bool? isSending,
    ChatMessage? replyToMessage,
    String? sendError,
    bool clearReply = false,
    bool clearError = false,
  }) =>
      ChatDetailLoaded(
        conversationId: conversationId ?? this.conversationId,
        messages: messages ?? this.messages,
        draftText: draftText ?? this.draftText,
        isSending: isSending ?? this.isSending,
        replyToMessage:
            clearReply ? null : (replyToMessage ?? this.replyToMessage),
        sendError: clearError ? null : (sendError ?? this.sendError),
      );

  @override
  List<Object?> get props => [
        conversationId,
        messages,
        draftText,
        isSending,
        replyToMessage,
        sendError
      ];
}

class ChatDetailError extends ChatDetailState {
  final String message;

  const ChatDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
