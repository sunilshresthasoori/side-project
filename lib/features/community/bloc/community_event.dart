part of 'community_bloc.dart';

abstract class CommunityEvent extends Equatable {
  const CommunityEvent();

  @override
  List<Object?> get props => [];
}

class CommunityFetchEvent extends CommunityEvent {
  const CommunityFetchEvent();
}

class CommunitySearchChangedEvent extends CommunityEvent {
  final String query;

  const CommunitySearchChangedEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class CommunityFilterChangedEvent extends CommunityEvent {
  final CommunityFilters filters;

  const CommunityFilterChangedEvent(this.filters);

  @override
  List<Object?> get props => [filters];
}

class CommunityFilterResetEvent extends CommunityEvent {
  const CommunityFilterResetEvent();
}

class CommunityStoryBookmarkToggled extends CommunityEvent {
  final String storyId;

  const CommunityStoryBookmarkToggled(this.storyId);

  @override
  List<Object?> get props => [storyId];
}
