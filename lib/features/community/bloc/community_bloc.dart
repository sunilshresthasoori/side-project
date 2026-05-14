import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../data/repositories/community_mock_repository.dart';
import '../domain/models/community_model.dart';

part 'community_event.dart';
part 'community_state.dart';

class CommunityBloc extends Bloc<CommunityEvent, CommunityState> {
  final CommunityMockRepository repository;

  CommunityBloc({required this.repository}) : super(const CommunityInitial()) {
    on<CommunityFetchEvent>(_onFetch);
    on<CommunitySearchChangedEvent>(_onSearchChanged);
    on<CommunityFilterChangedEvent>(_onFilterChanged);
    on<CommunityFilterResetEvent>(_onFilterReset);
    on<CommunityStoryBookmarkToggled>(_onBookmarkToggled);
  }

  Future<void> _onFetch(
    CommunityFetchEvent event,
    Emitter<CommunityState> emit,
  ) async {
    emit(const CommunityLoading());
    try {
      final stories = await repository.fetchStories();
      final filters = const CommunityFilters();
      final loaded = CommunityLoaded(
        allStories: stories,
        stories: _applyFilters(stories, filters, ''),
        filters: filters,
        query: '',
        locations: repository.getLocations(),
        difficulties: repository.getDifficulties(),
        contentTypes: repository.getContentTypes(),
        sortOptions: const [
          'Latest',
          'Most Liked',
          'Most Commented',
          'Most Shared',
        ],
      );
      emit(loaded);
    } catch (_) {
      emit(const CommunityError('Failed to load community stories.'));
    }
  }

  void _onSearchChanged(
    CommunitySearchChangedEvent event,
    Emitter<CommunityState> emit,
  ) {
    final state = this.state;
    if (state is! CommunityLoaded) return;
    final filtered =
        _applyFilters(state.allStories, state.filters, event.query);
    emit(state.copyWith(stories: filtered, query: event.query));
  }

  void _onFilterChanged(
    CommunityFilterChangedEvent event,
    Emitter<CommunityState> emit,
  ) {
    final state = this.state;
    if (state is! CommunityLoaded) return;
    final filtered =
        _applyFilters(state.allStories, event.filters, state.query);
    emit(state.copyWith(stories: filtered, filters: event.filters));
  }

  void _onFilterReset(
    CommunityFilterResetEvent event,
    Emitter<CommunityState> emit,
  ) {
    final state = this.state;
    if (state is! CommunityLoaded) return;
    const filters = CommunityFilters();
    final filtered = _applyFilters(state.allStories, filters, state.query);
    emit(state.copyWith(stories: filtered, filters: filters));
  }

  void _onBookmarkToggled(
    CommunityStoryBookmarkToggled event,
    Emitter<CommunityState> emit,
  ) {
    final state = this.state;
    if (state is! CommunityLoaded) return;
    final updatedAll = state.allStories
        .map(
          (story) => story.id == event.storyId
              ? story.copyWith(isBookmarked: !story.isBookmarked)
              : story,
        )
        .toList();
    final filtered = _applyFilters(updatedAll, state.filters, state.query);
    emit(state.copyWith(allStories: updatedAll, stories: filtered));
  }

  List<CommunityStory> _applyFilters(
    List<CommunityStory> stories,
    CommunityFilters filters,
    String query,
  ) {
    final lowerQuery = query.trim().toLowerCase();
    var filtered = stories.where((story) {
      final matchesQuery = lowerQuery.isEmpty ||
          story.title.toLowerCase().contains(lowerQuery) ||
          story.excerpt.toLowerCase().contains(lowerQuery) ||
          story.authorName.toLowerCase().contains(lowerQuery) ||
          story.trekName.toLowerCase().contains(lowerQuery) ||
          story.location.toLowerCase().contains(lowerQuery);

      final matchesLocation = filters.location == null ||
          story.location == filters.location;
      final matchesDifficulty = filters.difficulty == null ||
          story.difficulty == filters.difficulty;
      final matchesContentType = filters.contentType == null ||
          story.contentType == filters.contentType;

      return matchesQuery &&
          matchesLocation &&
          matchesDifficulty &&
          matchesContentType;
    }).toList();

    switch (filters.sortBy) {
      case 'Most Liked':
        filtered.sort((a, b) => b.likes.compareTo(a.likes));
        break;
      case 'Most Commented':
        filtered.sort((a, b) => b.comments.compareTo(a.comments));
        break;
      case 'Most Shared':
        filtered.sort((a, b) => b.shares.compareTo(a.shares));
        break;
      case 'Latest':
      default:
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
    }

    return filtered;
  }
}
