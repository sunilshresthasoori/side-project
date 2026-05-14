import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repository/explore_mock_repository.dart';
import '../domain/model/explore_model.dart';

part 'explore_event.dart';

part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final ExploreMockRepository _repo;

  ExploreBloc({ExploreMockRepository? repo})
      : _repo = repo ?? ExploreMockRepository(),
        super(const ExploreInitial()) {
    on<ExploreFetchEvent>(_onFetch);
    on<ExploreSearchChangedEvent>(_onSearchChanged);
    on<ExploreViewToggledEvent>(_onViewToggled);
    on<ExploreMoodFilterChangedEvent>(_onMoodChanged);
    on<ExploreFiltersAppliedEvent>(_onFiltersApplied);
    on<ExploreSingleFilterRemovedEvent>(_onSingleFilterRemoved);
    on<ExploreFiltersResetEvent>(_onFiltersReset);
    on<ExploreTrekBookmarkToggled>(_onBookmarkToggled);
    on<ExploreSeasonalAlertDismissedEvent>(_onAlertDismissed);
    on<ExploreMapTrekSelectedEvent>(_onMapTrekSelected);
    on<ExploreSortChangedEvent>(_onSortChanged);
  }

  //  FETCH
  Future<void> _onFetch(
      ExploreFetchEvent event, Emitter<ExploreState> emit) async {
    emit(const ExploreLoading());
    try {
      final results = await Future.wait([
        _repo.fetchTreks(),
        _repo.fetchRecentlyViewed(),
      ]);
      final treks = results[0] as List<ExploreTrek>;
      final recent = results[1] as List<RecentlyViewedTrek>;
      emit(ExploreLoaded(
        allTreks: treks,
        filteredTreks: treks,
        recentlyViewed: recent,
      ));
    } catch (e) {
      emit(ExploreError('Failed to load treks: $e'));
    }
  }

  //  SEARCH
  void _onSearchChanged(
      ExploreSearchChangedEvent event, Emitter<ExploreState> emit) {
    if (state is! ExploreLoaded) return;
    final s = state as ExploreLoaded;
    final filtered = _applyAll(
        s.allTreks, event.query, s.activeMood, s.activeFilters, s.activeSort);
    emit(s.copyWith(searchQuery: event.query, filteredTreks: filtered));
  }

  //  VIEW TOGGLE
  void _onViewToggled(
      ExploreViewToggledEvent event, Emitter<ExploreState> emit) {
    if (state is! ExploreLoaded) return;
    emit((state as ExploreLoaded).copyWith(activeView: event.view));
  }

  //  MOOD FILTER
  void _onMoodChanged(
      ExploreMoodFilterChangedEvent event, Emitter<ExploreState> emit) {
    if (state is! ExploreLoaded) return;
    final s = state as ExploreLoaded;
    final filtered = _applyAll(
        s.allTreks, s.searchQuery, event.mood, s.activeFilters, s.activeSort);
    emit(s.copyWith(activeMood: event.mood, filteredTreks: filtered));
  }

  //  FILTERS APPLIED
  void _onFiltersApplied(
      ExploreFiltersAppliedEvent event, Emitter<ExploreState> emit) {
    if (state is! ExploreLoaded) return;
    final s = state as ExploreLoaded;
    final filtered = _applyAll(
        s.allTreks, s.searchQuery, s.activeMood, event.filters, s.activeSort);
    emit(s.copyWith(activeFilters: event.filters, filteredTreks: filtered));
  }

  //  REMOVE ONE FILTER CHIP
  void _onSingleFilterRemoved(
      ExploreSingleFilterRemovedEvent event, Emitter<ExploreState> emit) {
    if (state is! ExploreLoaded) return;
    final s = state as ExploreLoaded;
    final f = s.activeFilters;
    ExploreFilters updated;

    if (event.filterKey.startsWith('loc:')) {
      final loc = event.filterKey.substring(4);
      updated =
          f.copyWith(locations: f.locations.where((l) => l != loc).toList());
    } else if (event.filterKey.startsWith('dif:')) {
      final dif = event.filterKey.substring(4);
      updated = f.copyWith(
          difficulties: f.difficulties.where((d) => d != dif).toList());
    } else if (event.filterKey.startsWith('sea:')) {
      final sea = event.filterKey.substring(4);
      updated =
          f.copyWith(seasons: f.seasons.where((se) => se != sea).toList());
    } else if (event.filterKey == 'dur') {
      updated = f.copyWith(durationMin: 1, durationMax: 30);
    } else if (event.filterKey == 'alt') {
      updated = f.copyWith(altitudeMin: 1000, altitudeMax: 9000);
    } else {
      updated = f;
    }

    final filtered = _applyAll(
        s.allTreks, s.searchQuery, s.activeMood, updated, s.activeSort);
    emit(s.copyWith(activeFilters: updated, filteredTreks: filtered));
  }

  //  RESET FILTERS
  void _onFiltersReset(
      ExploreFiltersResetEvent event, Emitter<ExploreState> emit) {
    if (state is! ExploreLoaded) return;
    final s = state as ExploreLoaded;
    final filtered = _applyAll(s.allTreks, s.searchQuery, s.activeMood,
        ExploreFilters.empty, s.activeSort);
    emit(s.copyWith(
        activeFilters: ExploreFilters.empty, filteredTreks: filtered));
  }

  //  BOOKMARK
  void _onBookmarkToggled(
      ExploreTrekBookmarkToggled event, Emitter<ExploreState> emit) {
    if (state is! ExploreLoaded) return;
    final s = state as ExploreLoaded;

    ExploreTrek toggle(ExploreTrek t) => t.id == event.trekId
        ? ExploreTrek(
            id: t.id,
            title: t.title,
            region: t.region,
            country: t.country,
            imagePath: t.imagePath,
            difficulty: t.difficulty,
            durationDays: t.durationDays,
            maxAltitudeM: t.maxAltitudeM,
            rating: t.rating,
            reviewCount: t.reviewCount,
            highlightTags: t.highlightTags,
            moods: t.moods,
            bestSeason: t.bestSeason,
            isTrending: t.isTrending,
            isBookmarked: !t.isBookmarked,
            isTrekOfWeek: t.isTrekOfWeek,
          )
        : t;

    emit(s.copyWith(
      allTreks: s.allTreks.map(toggle).toList(),
      filteredTreks: s.filteredTreks.map(toggle).toList(),
    ));
  }

  //  SEASONAL ALERT
  void _onAlertDismissed(
      ExploreSeasonalAlertDismissedEvent event, Emitter<ExploreState> emit) {
    if (state is! ExploreLoaded) return;
    emit((state as ExploreLoaded).copyWith(seasonalAlertVisible: false));
  }

  //  MAP SELECTION
  void _onMapTrekSelected(
      ExploreMapTrekSelectedEvent event, Emitter<ExploreState> emit) {
    if (state is! ExploreLoaded) return;
    final s = state as ExploreLoaded;
    if (event.trekId == null) {
      emit(s.copyWith(clearMapSelection: true));
    } else {
      emit(s.copyWith(selectedMapTrekId: event.trekId));
    }
  }

  //  SORT
  void _onSortChanged(
      ExploreSortChangedEvent event, Emitter<ExploreState> emit) {
    if (state is! ExploreLoaded) return;
    final s = state as ExploreLoaded;
    final filtered = _applyAll(
        s.allTreks, s.searchQuery, s.activeMood, s.activeFilters, event.sort);
    emit(s.copyWith(activeSort: event.sort, filteredTreks: filtered));
  }

  //  UNIFIED FILTER + SEARCH + SORT
  List<ExploreTrek> _applyAll(
    List<ExploreTrek> source,
    String query,
    String mood,
    ExploreFilters filters,
    ExploreSort sort,
  ) {
    var result = source.where((t) {
      // Search
      if (query.isNotEmpty) {
        final q = query.toLowerCase();
        if (!t.title.toLowerCase().contains(q) &&
            !t.region.toLowerCase().contains(q) &&
            !t.highlightTags.any((tag) => tag.toLowerCase().contains(q))) {
          return false;
        }
      }
      // Mood
      if (mood != 'all' && !t.moods.contains(mood)) return false;
      // Location
      if (filters.locations.isNotEmpty && !filters.locations.contains(t.region))
        return false;
      // Difficulty
      if (filters.difficulties.isNotEmpty &&
          !filters.difficulties.contains(t.difficulty)) return false;
      // Duration
      if (t.durationDays < filters.durationMin ||
          t.durationDays > filters.durationMax) return false;
      // Altitude
      if (t.maxAltitudeM < filters.altitudeMin ||
          t.maxAltitudeM > filters.altitudeMax) return false;
      // Season
      if (filters.seasons.isNotEmpty && !filters.seasons.contains(t.bestSeason))
        return false;
      return true;
    }).toList();

    // Sort
    switch (sort) {
      case ExploreSort.mostPopular:
        result.sort((a, b) => b.reviewCount.compareTo(a.reviewCount));
      case ExploreSort.highestRated:
        result.sort((a, b) => b.rating.compareTo(a.rating));
      case ExploreSort.shortestFirst:
        result.sort((a, b) => a.durationDays.compareTo(b.durationDays));
      case ExploreSort.longestFirst:
        result.sort((a, b) => b.durationDays.compareTo(a.durationDays));
    }
    return result;
  }
}
