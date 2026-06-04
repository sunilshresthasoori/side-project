import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repository/explore_remote_repository.dart';
import '../domain/model/explore_model.dart';
import '../domain/usecases/get_destinations.dart';
import '../service/explore_filter_model.dart';

part 'explore_event.dart';
part 'explore_state.dart';

class ExploreBloc extends Bloc<ExploreEvent, ExploreState> {
  final GetDestinations _getDestinations;

  ExploreBloc({GetDestinations? getDestinations})
      : _getDestinations = getDestinations ??
      GetDestinations(ExploreRemoteRepository()),
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
      ExploreFetchEvent event,
      Emitter<ExploreState> emit,
      ) async {
    emit(const ExploreLoading());
    try {
      final request = _buildRequest(
        query: '',
        mood: 'all',
        filters: ExploreFilters.empty,
        sort: ExploreSort.mostPopular,
        page: 0,
      );

      final response = await _getDestinations(request);
      final treks = response.data.map(ExploreTrek.fromDestination).toList();

      emit(ExploreLoaded(
        allTreks: treks,
        filteredTreks: treks,
        recentlyViewed: const [],
      ));
    } catch (e) {
      emit(ExploreError('Failed to load treks: $e'));
    }
  }

  //  SEARCH
  void _onSearchChanged(
      ExploreSearchChangedEvent event, Emitter<ExploreState> emit) async {
    if (state is! ExploreLoaded) return;
    final s = state as ExploreLoaded;
    await _fetchTreks(
      emit,
      s,
      query: event.query,
    );
  }

  //  VIEW TOGGLE
  void _onViewToggled(
      ExploreViewToggledEvent event, Emitter<ExploreState> emit) {
    if (state is! ExploreLoaded) return;
    emit((state as ExploreLoaded).copyWith(activeView: event.view));
  }

  //  MOOD FILTER
  void _onMoodChanged(
      ExploreMoodFilterChangedEvent event, Emitter<ExploreState> emit) async {
    if (state is! ExploreLoaded) return;
    final s = state as ExploreLoaded;
    await _fetchTreks(
      emit,
      s,
      mood: event.mood,
    );
  }

  //  FILTERS APPLIED
  void _onFiltersApplied(
      ExploreFiltersAppliedEvent event, Emitter<ExploreState> emit) async {
    if (state is! ExploreLoaded) return;
    final s = state as ExploreLoaded;
    await _fetchTreks(
      emit,
      s,
      filters: event.filters,
    );
  }

  //  REMOVE ONE FILTER CHIP
  void _onSingleFilterRemoved(
      ExploreSingleFilterRemovedEvent event, Emitter<ExploreState> emit) async {
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

    await _fetchTreks(
      emit,
      s,
      filters: updated,
    );
  }

  //  RESET FILTERS
  void _onFiltersReset(
      ExploreFiltersResetEvent event, Emitter<ExploreState> emit) async {
    if (state is! ExploreLoaded) return;
    final s = state as ExploreLoaded;
    await _fetchTreks(
      emit,
      s,
      filters: ExploreFilters.empty,
    );
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
      destinationType: t.destinationType,
      province: t.province,
      district: t.district,
      localLevel: t.localLevel,
      primaryAccessCity: t.primaryAccessCity,
      distanceFromAccessCity: t.distanceFromAccessCity,
      description: t.description,
      latitude: t.latitude,
      longitude: t.longitude,
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

  FilterRequest _buildRequest({
    required String query,
    required String mood,
    required ExploreFilters filters,
    required ExploreSort sort,
    required int page,
  }) {
    final criteria = <FilterCriterionRequest>[];

    for (final location in filters.locations) {
      criteria.add(FilterCriterionRequest(key: 'province', value: location));
    }

    for (final difficulty in filters.difficulties) {
      criteria
          .add(FilterCriterionRequest(key: 'difficulty', value: difficulty));
    }

    for (final season in filters.seasons) {
      criteria.add(FilterCriterionRequest(key: 'season', value: season));
    }

    if (mood != 'all') {
      criteria.add(FilterCriterionRequest(key: 'mood', value: mood));
    }

    final sortBy = _mapSortToField(sort);

    return FilterRequest(
      search: query,
      filterCriteriaRequests: criteria,
      paginationRequest: PaginationRequest(
        page: page,
        size: 10,
        sortBy: sortBy,
      ),
    );
  }

  String _mapSortToField(ExploreSort sort) {
    switch (sort) {
      case ExploreSort.mostPopular:
        return 'name';
      case ExploreSort.highestRated:
        return 'name';
      case ExploreSort.shortestFirst:
        return 'name';
      case ExploreSort.longestFirst:
        return 'name';
    }
  }

  //  SORT
  void _onSortChanged(
      ExploreSortChangedEvent event, Emitter<ExploreState> emit) async {
    if (state is! ExploreLoaded) return;
    final s = state as ExploreLoaded;
    await _fetchTreks(
      emit,
      s,
      sort: event.sort,
    );
  }

  Future<void> _fetchTreks(
      Emitter<ExploreState> emit,
      ExploreLoaded state, {
        String? query,
        String? mood,
        ExploreFilters? filters,
        ExploreSort? sort,
      }) async {
    final nextQuery = query ?? state.searchQuery;
    final nextMood = mood ?? state.activeMood;
    final nextFilters = filters ?? state.activeFilters;
    final nextSort = sort ?? state.activeSort;

    try {
      final request = _buildRequest(
        query: nextQuery,
        mood: nextMood,
        filters: nextFilters,
        sort: nextSort,
        page: 0,
      );

      final response = await _getDestinations(request);
      final treks = response.data.map(ExploreTrek.fromDestination).toList();

      emit(state.copyWith(
        searchQuery: nextQuery,
        activeMood: nextMood,
        activeFilters: nextFilters,
        activeSort: nextSort,
        allTreks: treks,
        filteredTreks: treks,
      ));
    } catch (e) {
      emit(ExploreError('Failed to load treks: $e'));
    }
  }
}