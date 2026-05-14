part of 'home_bloc.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();

  @override
  List<Object?> get props => [];
}

class HomeLoading extends HomeState {
  const HomeLoading();

  @override
  List<Object?> get props => [];
}

class HomeLoaded extends HomeState {
  final List<TrekCategory> categories;
  final List<FeaturedTrek> featuredTreks;
  final List<CommunityStory> communityStories;
  final String searchQuery;

  const HomeLoaded({
    required this.categories,
    required this.featuredTreks,
    required this.communityStories,
    this.searchQuery = "",
  });

  HomeLoaded copyWith({
    List<TrekCategory>? categories,
    List<FeaturedTrek>? featuredTrek,
    List<CommunityStory>? communityStories,
    String? searchQuery,
  }) =>
      HomeLoaded(
        categories: categories ?? this.categories,
        featuredTreks: featuredTrek ?? this.featuredTreks,
        communityStories: communityStories ?? this.communityStories,
        searchQuery: searchQuery ?? this.searchQuery,
      );

  @override
  List<Object?> get props =>
      [categories, featuredTreks, communityStories, searchQuery];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
