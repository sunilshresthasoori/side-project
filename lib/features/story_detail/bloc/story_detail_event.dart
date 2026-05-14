part of 'story_detail_bloc.dart';

abstract class StoryDetailEvent extends Equatable {
  const StoryDetailEvent();

  @override
  List<Object?> get props => [];
}

class StoryDetailFetchEvent extends StoryDetailEvent {
  final String storyId;

  const StoryDetailFetchEvent(this.storyId);

  @override
  List<Object?> get props => [storyId];
}

class StoryDetailCommentPostedEvent extends StoryDetailEvent {
  final String text;

  const StoryDetailCommentPostedEvent(this.text);

  @override
  List<Object?> get props => [text];
}

class StoryDetailCommentLikedEvent extends StoryDetailEvent {
  final String commentId;

  const StoryDetailCommentLikedEvent(this.commentId);

  @override
  List<Object?> get props => [commentId];
}

class StoryDetailShareEvent extends StoryDetailEvent {
  const StoryDetailShareEvent();
}
