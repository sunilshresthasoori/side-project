
part of 'explore_bloc.dart';

abstract class ExploreState extends Equatable {
  const ExploreState();
  @override
  List<Object?> get props => [];
}

class ExploreInitial extends ExploreState {
  const ExploreInitial();
}

class ExploreLoading extends ExploreState {
  const ExploreLoading();
}

class ExploreLoaded extends ExploreState {
  final List<ExploreTrek>        allTreks;
  final List<ExploreTrek>        filteredTreks;
  final List<RecentlyViewedTrek> recentlyViewed;
  final ExploreFilters           activeFilters;
  final String                   searchQuery;
  final String                   activeMood;      // 'all' by default
  final ExploreView              activeView;
  final ExploreSort              activeSort;
  final bool                     seasonalAlertVisible;
  final String?                  selectedMapTrekId;

  const ExploreLoaded({
    required this.allTreks,
    required this.filteredTreks,
    required this.recentlyViewed,
    this.activeFilters        = ExploreFilters.empty,
    this.searchQuery          = '',
    this.activeMood           = 'all',
    this.activeView           = ExploreView.grid,
    this.activeSort           = ExploreSort.mostPopular,
    this.seasonalAlertVisible = true,
    this.selectedMapTrekId,
  });

  ExploreLoaded copyWith({
    List<ExploreTrek>?        allTreks,
    List<ExploreTrek>?        filteredTreks,
    List<RecentlyViewedTrek>? recentlyViewed,
    ExploreFilters?           activeFilters,
    String?                   searchQuery,
    String?                   activeMood,
    ExploreView?              activeView,
    ExploreSort?              activeSort,
    bool?                     seasonalAlertVisible,
    String?                   selectedMapTrekId,
    bool                      clearMapSelection = false,
  }) =>
      ExploreLoaded(
        allTreks:             allTreks             ?? this.allTreks,
        filteredTreks:        filteredTreks        ?? this.filteredTreks,
        recentlyViewed:       recentlyViewed       ?? this.recentlyViewed,
        activeFilters:        activeFilters        ?? this.activeFilters,
        searchQuery:          searchQuery          ?? this.searchQuery,
        activeMood:           activeMood           ?? this.activeMood,
        activeView:           activeView           ?? this.activeView,
        activeSort:           activeSort           ?? this.activeSort,
        seasonalAlertVisible: seasonalAlertVisible ?? this.seasonalAlertVisible,
        selectedMapTrekId:    clearMapSelection ? null : (selectedMapTrekId ?? this.selectedMapTrekId),
      );

  @override
  List<Object?> get props => [
    allTreks, filteredTreks, recentlyViewed, activeFilters,
    searchQuery, activeMood, activeView, activeSort,
    seasonalAlertVisible, selectedMapTrekId,
  ];
}

class ExploreError extends ExploreState {
  final String message;
  const ExploreError(this.message);
  @override
  List<Object?> get props => [message];
}