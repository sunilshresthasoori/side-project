part of 'story_detail_bloc.dart';

abstract class StoryDetailState extends Equatable {
  const StoryDetailState();

  @override
  List<Object?> get props => [];
}

class StoryDetailInitial extends StoryDetailState {
  const StoryDetailInitial();
}

class StoryDetailLoading extends StoryDetailState {
  const StoryDetailLoading();
}

class StoryDetailLoaded extends StoryDetailState {
  final StoryDetail story;

  const StoryDetailLoaded(this.story);

  StoryDetailLoaded copyWith({StoryDetail? story}) {
    return StoryDetailLoaded(story ?? this.story);
  }

  @override
  List<Object?> get props => [story];
}

class StoryDetailError extends StoryDetailState {
  final String message;

  const StoryDetailError(this.message);

  @override
  List<Object?> get props => [message];
}
