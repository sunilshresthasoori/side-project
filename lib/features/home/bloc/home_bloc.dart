import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../data/repository/home_mock_repo.dart';
import '../domain/models/trek_models.dart';

part 'home_event.dart';

part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeMockRepository _repository;

  HomeBloc({HomeMockRepository? repository})
      : _repository = repository ?? HomeMockRepository(),
        super(const HomeInitial()) {
    on<FetchHomeDataEvent>(_onFetchData);
    on<SearchHomeEvent>(_onSearchData);
    on<ToggleFavouriteTrekIconEvent>(_onTrekFavoriteToggled);
    on<ToggleFavouriteTrekStoryEvent>(_onStoryLikedToggled);
  }

// fetch data implementation
  Future<void> _onFetchData(
    FetchHomeDataEvent event,
    Emitter<HomeState> emit,
  ) async {
    emit(const HomeLoading());
    try {
      // all three APIs fires at once
      final results = await Future.wait([
        _repository.fetchCategories(),
        _repository.fetchFeaturedTrek(),
        _repository.fetchCommunityStories(),
      ]);

      emit(HomeLoaded(
        categories: results[0] as List<TrekCategory>,
        featuredTreks: results[1] as List<FeaturedTrek>,
        communityStories: results[2] as List<CommunityStory>,
      ));
    } catch (e) {
      emit(HomeError('Failed to load data: ${e.toString()}'));
    }
  }

  //search event implementation
  void _onSearchData(SearchHomeEvent event, Emitter<HomeState> emit) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      emit(current.copyWith(searchQuery: event.query));
    }
  }
  //clicking on favourite icon
  void _onTrekFavoriteToggled(
    ToggleFavouriteTrekIconEvent event,
    Emitter<HomeState> emit,
  ) {
    if (state is HomeLoaded) {
      final current = state as HomeLoaded;
      final updated = current.featuredTreks.map((trek) {
        if (trek.id == event.trekId) {
          return FeaturedTrek(
            id: trek.id,
            title: trek.title,
            region: trek.region,
            imagePath: trek.imagePath,
            durationDays: trek.durationDays,
            altitudeM: trek.altitudeM,
            priceNpr: trek.priceNpr,
            rating: trek.rating,
            reviewCount: trek.reviewCount,
            difficulty: trek.difficulty,
            isFavourite: !trek.isFavourite,
          );
        }
        return trek;
      }).toList();
      emit(current.copyWith(featuredTrek: updated));
    }
  }


  //liking a community story
  void _onStoryLikedToggled(ToggleFavouriteTrekStoryEvent event, Emitter<HomeState>emit,){
    if(state is HomeLoaded){
      final current = state as HomeLoaded;
      final updated = current.communityStories.map((communityStory){
        if(communityStory.id == event.storyId){
          return CommunityStory(
              imagePath: communityStory.imagePath,
              authorAvatarPath: communityStory.authorAvatarPath,
              authorName: communityStory.authorName,
              comments: communityStory.comments,
              excerpt: communityStory.excerpt,
              id: communityStory.id,
              likes: communityStory.likes+1,
              tags: communityStory.tags,
              timeAgo: communityStory.timeAgo,
              title: communityStory.title
          );
        }
      });
    }
  }
}
