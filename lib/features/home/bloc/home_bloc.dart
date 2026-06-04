import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:trekkers_odyssey_v2/features/home/data/repository/home_repo.dart';
import '../domain/models/trek_models.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository _repository;

  HomeBloc({HomeRepository? repository})
      : _repository = repository ?? HomeRepository(),
        super(const HomeInitial()) {
    on<FetchHomeDataEvent>(_onFetchData);
    on<SearchHomeEvent>(_onSearchData);
    on<ToggleFavouriteTrekIconEvent>(_onTrekFavoriteToggled);
    on<ToggleFavouriteTrekStoryEvent>(_onStoryLikedToggled);
  }

  Future<void> _onFetchData(
      FetchHomeDataEvent event,
      Emitter<HomeState> emit,
      ) async {
    emit(const HomeLoading());
    try {
      final results = await Future.wait([
        _repository.fetchCategories(),
        _repository.fetchFeaturedTreks(),
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
          return trek.copyWith(isFavourite: !trek.isFavourite);
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
      emit(current.copyWith(communityStories: current.communityStories.map((communityStory){
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
        return communityStory;
      }).toList()));
    }
  }
}
