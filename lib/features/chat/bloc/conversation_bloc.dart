import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../domain/model/chat.dart';
import '../data/repository/chat_mock_repository.dart';

part 'conversation_event.dart';
part 'conversation_state.dart';

class ConversationsBloc extends Bloc<ConversationsEvent, ConversationsState> {
  final ChatMockRepository _repo;

  ConversationsBloc({ChatMockRepository? repo})
      : _repo = repo ?? ChatMockRepository(),
        super(const ConversationsInitial()) {
    on<ConversationsFetchEvent>(_onFetch);
    on<ConversationsSearchChangedEvent>(_onSearch);
    on<ConversationMutedEvent>(_onMute);
    on<ConversationPinnedEvent>(_onPin);
  }

  Future<void> _onFetch(
    ConversationsFetchEvent event,
    Emitter<ConversationsState> emit,
  ) async {
    emit(const ConversationsLoading());
    try {
      final list = await _repo.fetchConversations();
      emit(ConversationsLoaded(
        all: list,
        filtered: list,
      ));
    } catch (e) {
      emit(ConversationsError('Failed to load chats: $e'));
    }
  }

  void _onSearch(
    ConversationsSearchChangedEvent event,
    Emitter<ConversationsState> emit,
  ) {
    if (state is! ConversationsLoaded) return;
    final s = state as ConversationsLoaded;
    final q = event.query.toLowerCase();
    final filtered = q.isEmpty
        ? s.all
        : s.all.where((c) => c.displayName.toLowerCase().contains(q)).toList();
    emit(s.copyWith(filtered: filtered, searchQuery: event.query));
  }

  void _onMute(
    ConversationMutedEvent event,
    Emitter<ConversationsState> emit,
  ) {
    if (state is! ConversationsLoaded) return;
    final s = state as ConversationsLoaded;
    _updateConversation(
        s,
        event.conversationId,
        emit,
        (c) => Conversation(
              id: c.id,
              participants: c.participants,
              lastMessage: c.lastMessage,
              unreadCount: c.unreadCount,
              isGroup: c.isGroup,
              groupName: c.groupName,
              groupAvatarPath: c.groupAvatarPath,
              isMuted: !c.isMuted,
              isPinned: c.isPinned,
            ));
  }

  void _onPin(
    ConversationPinnedEvent event,
    Emitter<ConversationsState> emit,
  ) {
    if (state is! ConversationsLoaded) return;
    final s = state as ConversationsLoaded;
    _updateConversation(
        s,
        event.conversationId,
        emit,
        (c) => Conversation(
              id: c.id,
              participants: c.participants,
              lastMessage: c.lastMessage,
              unreadCount: c.unreadCount,
              isGroup: c.isGroup,
              groupName: c.groupName,
              groupAvatarPath: c.groupAvatarPath,
              isMuted: c.isMuted,
              isPinned: !c.isPinned,
            ));
  }

  void _updateConversation(
    ConversationsLoaded s,
    String id,
    Emitter<ConversationsState> emit,
    Conversation Function(Conversation) update,
  ) {
    final updated = s.all.map((c) => c.id == id ? update(c) : c).toList();
    final filteredUpdated =
        s.filtered.map((c) => c.id == id ? update(c) : c).toList();
    emit(s.copyWith(all: updated, filtered: filteredUpdated));
  }
}
