import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/repositories/story_detail_mock_repository.dart';
import '../domain/models/story_detail_model.dart';

part 'story_detail_event.dart';
part 'story_detail_state.dart';

class StoryDetailBloc extends Bloc<StoryDetailEvent, StoryDetailState> {
  final StoryDetailMockRepository repository;

  StoryDetailBloc({required this.repository})
      : super(const StoryDetailInitial()) {
    on<StoryDetailFetchEvent>(_onFetch);
    on<StoryDetailCommentPostedEvent>(_onCommentPosted);
    on<StoryDetailCommentLikedEvent>(_onCommentLiked);
    on<StoryDetailShareEvent>(_onShare);
  }

  Future<void> _onFetch(
    StoryDetailFetchEvent event,
    Emitter<StoryDetailState> emit,
  ) async {
    emit(const StoryDetailLoading());
    try {
      final story = await repository.fetchStoryDetail(event.storyId);
      emit(StoryDetailLoaded(story));
    } catch (_) {
      emit(const StoryDetailError('Failed to load story details.'));
    }
  }

  void _onCommentPosted(
    StoryDetailCommentPostedEvent event,
    Emitter<StoryDetailState> emit,
  ) {
    final state = this.state;
    if (state is! StoryDetailLoaded) return;
    final trimmed = event.text.trim();
    if (trimmed.isEmpty) return;

    final newComment = StoryComment(
      id: 'comment-${DateTime.now().millisecondsSinceEpoch}',
      authorName: 'You',
      authorAvatarPath: 'assets/images/avatars/avatar_10.jpg',
      text: trimmed,
      date: DateTime.now(),
      likes: 0,
      isLiked: false,
    );

    final updated = state.story.copyWith(
      commentList: [newComment, ...state.story.commentList],
      comments: state.story.comments + 1,
    );
    emit(state.copyWith(story: updated));
  }

  void _onCommentLiked(
    StoryDetailCommentLikedEvent event,
    Emitter<StoryDetailState> emit,
  ) {
    final state = this.state;
    if (state is! StoryDetailLoaded) return;

    final updatedComments = state.story.commentList.map((comment) {
      if (comment.id != event.commentId) return comment;
      final isLiked = !comment.isLiked;
      return comment.copyWith(
        isLiked: isLiked,
        likes: isLiked ? comment.likes + 1 : comment.likes - 1,
      );
    }).toList();

    emit(state.copyWith(
      story: state.story.copyWith(commentList: updatedComments),
    ));
  }

  void _onShare(
    StoryDetailShareEvent event,
    Emitter<StoryDetailState> emit,
  ) {
    final state = this.state;
    if (state is! StoryDetailLoaded) return;
    emit(state.copyWith(
      story: state.story.copyWith(shares: state.story.shares + 1),
    ));
  }
}
