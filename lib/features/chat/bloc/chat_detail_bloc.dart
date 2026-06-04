import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../domain/model/chat.dart';
import '../data/repository/chat_mock_repository.dart';

part 'chat_detail_event.dart';
part 'chat_detail_state.dart';

class ChatDetailBloc extends Bloc<ChatDetailEvent, ChatDetailState> {
  final ChatMockRepository _repo;

  ChatDetailBloc({ChatMockRepository? repo})
      : _repo = repo ?? ChatMockRepository(),
        super(const ChatDetailInitial()) {
    on<ChatDetailFetchEvent>(_onFetch);
    on<ChatDetailMessageChangedEvent>(_onMessageChanged);
    on<ChatDetailSendEvent>(_onSend);
    on<ChatDetailReplySetEvent>(_onReplySet);
    on<ChatDetailReplyClearedEvent>(_onReplyCleared);
  }

  Future<void> _onFetch(
    ChatDetailFetchEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    emit(const ChatDetailLoading());
    try {
      final msgs = await _repo.fetchMessages(event.conversationId);
      emit(ChatDetailLoaded(
        conversationId: event.conversationId,
        messages: msgs,
        draftText: '',
      ));
    } catch (e) {
      emit(ChatDetailError('Failed to load messages: $e'));
    }
  }

  void _onMessageChanged(
    ChatDetailMessageChangedEvent event,
    Emitter<ChatDetailState> emit,
  ) {
    if (state is! ChatDetailLoaded) return;
    emit((state as ChatDetailLoaded).copyWith(draftText: event.text));
  }

  Future<void> _onSend(
    ChatDetailSendEvent event,
    Emitter<ChatDetailState> emit,
  ) async {
    if (state is! ChatDetailLoaded) return;
    final s = state as ChatDetailLoaded;
    if (s.draftText.trim().isEmpty) return;

    // Optimistic: add as sending immediately
    final optimistic = ChatMessage(
      id: 'opt_${DateTime.now().millisecondsSinceEpoch}',
      conversationId: s.conversationId,
      senderId: 'me',
      content: s.draftText.trim(),
      timestamp: DateTime.now(),
      isMe: true,
      status: MessageStatus.sending,
      replyToId: s.replyToMessage?.id,
      replyPreview: s.replyToMessage?.content,
    );

    emit(s.copyWith(
      messages: [...s.messages, optimistic],
      draftText: '',
      isSending: true,
      clearReply: true,
    ));

    try {
      final sent = await _repo.sendMessage(
        conversationId: s.conversationId,
        content: optimistic.content,
        replyToId: optimistic.replyToId,
        replyPreview: optimistic.replyPreview,
      );
      final current = state as ChatDetailLoaded;
      final updated = current.messages
          .map((m) => m.id == optimistic.id ? sent : m)
          .toList();
      emit(current.copyWith(messages: updated, isSending: false));
    } catch (e) {
      // Mark message as failed
      final current = state as ChatDetailLoaded;
      emit(current.copyWith(isSending: false, sendError: 'Failed to send'));
    }
  }

  void _onReplySet(
    ChatDetailReplySetEvent event,
    Emitter<ChatDetailState> emit,
  ) {
    if (state is! ChatDetailLoaded) return;
    emit((state as ChatDetailLoaded).copyWith(replyToMessage: event.message));
  }

  void _onReplyCleared(
    ChatDetailReplyClearedEvent event,
    Emitter<ChatDetailState> emit,
  ) {
    if (state is! ChatDetailLoaded) return;
    emit((state as ChatDetailLoaded).copyWith(clearReply: true));
  }
}
