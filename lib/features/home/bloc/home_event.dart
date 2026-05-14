part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchHomeDataEvent extends HomeEvent {
  const FetchHomeDataEvent();

  @override
  List<Object?> get props => [];
}

class SearchHomeEvent extends HomeEvent {
  final String query;

  const SearchHomeEvent(this.query);

  @override
  List<Object?> get props => [query];
}

class ToggleFavouriteTrekIconEvent extends HomeEvent {
  final String trekId;

  const ToggleFavouriteTrekIconEvent(this.trekId);

  @override
  List<Object?> get props => [trekId];
}

class ToggleFavouriteTrekStoryEvent extends HomeEvent {
  final String storyId;

  const ToggleFavouriteTrekStoryEvent(this.storyId);

  @override
  List<Object?> get props => [storyId];
}
