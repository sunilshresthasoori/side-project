import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';


import '../data/repository/trek_detail_mock_repository.dart';
import '../domain/models/trek_detail_model.dart';

part 'trek_detail_event.dart';

part 'trek_detail_state.dart';

class TrekDetailBloc extends Bloc<TrekDetailEvent, TrekDetailState> {
  final TrekDetailMockRepository _repo;

  TrekDetailBloc({TrekDetailMockRepository? repo})
      : _repo = repo ?? TrekDetailMockRepository(),
        super(const TrekDetailInitial()) {
    on<TrekDetailFetchEvent>(_onFetch);
    on<TrekDetailTabChangedEvent>(_onTabChanged);
    on<TrekDetailGalleryChangedEvent>(_onGalleryChanged);
    on<TrekDetailSaveToggledEvent>(_onSaveToggled);
    on<TrekDetailItineraryDayTappedEvent>(_onItineraryTapped);
  }

  Future<void> _onFetch(
      TrekDetailFetchEvent event, Emitter<TrekDetailState> emit) async {
    emit(const TrekDetailLoading());
    try {
      final detail = await _repo.fetchTrekDetail(event.trekId);
      emit(TrekDetailLoaded(detail: detail));
    } catch (e) {
      emit(TrekDetailError('Failed to load trek: ${e.toString()}'));
    }
  }

  void _onTabChanged(
      TrekDetailTabChangedEvent event, Emitter<TrekDetailState> emit) {
    if (state is TrekDetailLoaded) {
      emit((state as TrekDetailLoaded).copyWith(activeTab: event.tab));
    }
  }

  void _onGalleryChanged(
      TrekDetailGalleryChangedEvent event, Emitter<TrekDetailState> emit) {
    if (state is TrekDetailLoaded) {
      emit((state as TrekDetailLoaded).copyWith(galleryIndex: event.index));
    }
  }

  void _onSaveToggled(
    TrekDetailSaveToggledEvent event,
    Emitter<TrekDetailState> emit,
  ) {
    if (state is TrekDetailLoaded) {
      final s = state as TrekDetailLoaded;
      final updated = TrekDetail(
        id: s.detail.id,
        title: s.detail.title,
        region: s.detail.region,
        country: s.detail.country,
        galleryImages: s.detail.galleryImages,
        galleryCaptions: s.detail.galleryCaptions,
        aboutText: s.detail.aboutText,
        difficulty: s.detail.difficulty,
        durationDays: s.detail.durationDays,
        distanceKm: s.detail.distanceKm,
        maxAltitudeM: s.detail.maxAltitudeM,
        bestSeason: s.detail.bestSeason,
        priceNPR: s.detail.priceNPR,
        ratingSummary: s.detail.ratingSummary,
        routePoints: s.detail.routePoints,
        itinerary: s.detail.itinerary,
        hotels: s.detail.hotels,
        reviews: s.detail.reviews,
        permits: s.detail.permits,
        packingList: s.detail.packingList,
        isSaved: !s.detail.isSaved,
      );
      emit(s.copyWith(detail: updated));
    }
  }

  void _onItineraryTapped(
    TrekDetailItineraryDayTappedEvent event,
    Emitter<TrekDetailState> emit,
  ) {
    if (state is TrekDetailLoaded) {
      final s = state as TrekDetailLoaded;
      final current = s.expandedDayIndex;
      emit(s.copyWith(
          expandedDayIndex: current == event.dayIndex ? -1 : event.dayIndex));
    }
  }
}
