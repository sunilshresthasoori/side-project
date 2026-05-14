part of 'community_bloc.dart';

abstract class CommunityState extends Equatable {
  const CommunityState();

  @override
  List<Object?> get props => [];
}

class CommunityInitial extends CommunityState {
  const CommunityInitial();
}

class CommunityLoading extends CommunityState {
  const CommunityLoading();
}

class CommunityLoaded extends CommunityState {
  final List<CommunityStory> allStories;
  final List<CommunityStory> stories;
  final CommunityFilters filters;
  final String query;
  final List<String> locations;
  final List<String> difficulties;
  final List<String> contentTypes;
  final List<String> sortOptions;

  const CommunityLoaded({
    required this.allStories,
    required this.stories,
    required this.filters,
    required this.query,
    required this.locations,
    required this.difficulties,
    required this.contentTypes,
    required this.sortOptions,
  });

  CommunityLoaded copyWith({
    List<CommunityStory>? allStories,
    List<CommunityStory>? stories,
    CommunityFilters? filters,
    String? query,
    List<String>? locations,
    List<String>? difficulties,
    List<String>? contentTypes,
    List<String>? sortOptions,
  }) {
    return CommunityLoaded(
      allStories: allStories ?? this.allStories,
      stories: stories ?? this.stories,
      filters: filters ?? this.filters,
      query: query ?? this.query,
      locations: locations ?? this.locations,
      difficulties: difficulties ?? this.difficulties,
      contentTypes: contentTypes ?? this.contentTypes,
      sortOptions: sortOptions ?? this.sortOptions,
    );
  }

  @override
  List<Object?> get props => [
        allStories,
        stories,
        filters,
        query,
        locations,
        difficulties,
        contentTypes,
        sortOptions,
      ];
}

class CommunityError extends CommunityState {
  final String message;

  const CommunityError(this.message);

  @override
  List<Object?> get props => [message];
}
