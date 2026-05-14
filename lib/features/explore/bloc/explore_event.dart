part of 'explore_bloc.dart';

abstract class ExploreEvent extends Equatable {
  const ExploreEvent();
  @override
  List<Object?> get props => [];
}

class ExploreFetchEvent extends ExploreEvent {
  const ExploreFetchEvent();
}

class ExploreSearchChangedEvent extends ExploreEvent {
  final String query;
  const ExploreSearchChangedEvent(this.query);
  @override
  List<Object?> get props => [query];
}

class ExploreViewToggledEvent extends ExploreEvent {
  final ExploreView view;
  const ExploreViewToggledEvent(this.view);
  @override
  List<Object?> get props => [view];
}

class ExploreMoodFilterChangedEvent extends ExploreEvent {
  final String mood; // 'all' | 'highAltitude' | etc.
  const ExploreMoodFilterChangedEvent(this.mood);
  @override
  List<Object?> get props => [mood];
}

class ExploreFiltersAppliedEvent extends ExploreEvent {
  final ExploreFilters filters;
  const ExploreFiltersAppliedEvent(this.filters);
  @override
  List<Object?> get props => [filters];
}

class ExploreSingleFilterRemovedEvent extends ExploreEvent {
  final String filterKey; // e.g. 'loc:Khumbu' | 'dif:Hard' | 'sea:Spring'
  const ExploreSingleFilterRemovedEvent(this.filterKey);
  @override
  List<Object?> get props => [filterKey];
}

class ExploreFiltersResetEvent extends ExploreEvent {
  const ExploreFiltersResetEvent();
}

class ExploreTrekBookmarkToggled extends ExploreEvent {
  final String trekId;
  const ExploreTrekBookmarkToggled(this.trekId);
  @override
  List<Object?> get props => [trekId];
}

class ExploreSeasonalAlertDismissedEvent extends ExploreEvent {
  const ExploreSeasonalAlertDismissedEvent();
}

class ExploreMapTrekSelectedEvent extends ExploreEvent {
  final String? trekId; // null = deselect
  const ExploreMapTrekSelectedEvent(this.trekId);
  @override
  List<Object?> get props => [trekId];
}

class ExploreSortChangedEvent extends ExploreEvent {
  final ExploreSort sort;
  const ExploreSortChangedEvent(this.sort);
  @override
  List<Object?> get props => [sort];
}