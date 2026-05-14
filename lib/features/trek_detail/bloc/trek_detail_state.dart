part of 'trek_detail_bloc.dart';

//the tabs matching horizontal tab bar
enum TrekDetailTab {
  overview,
  routeMap,
  itinerary,
  hotels,
  reviews,
  safety,
}

abstract class TrekDetailState extends Equatable {
  const TrekDetailState();

  @override
  List<Object?> get props => [];
}

class TrekDetailInitial extends TrekDetailState {
  const TrekDetailInitial();
}

class TrekDetailLoading extends TrekDetailState {
  const TrekDetailLoading();
}

class TrekDetailLoaded extends TrekDetailState {
  final TrekDetail detail;
  final TrekDetailTab activeTab;
  final int galleryIndex;
  final int expandedDayIndex;

  const TrekDetailLoaded(
      {required this.detail,
      this.activeTab = TrekDetailTab.overview,
      this.galleryIndex = 0,
      this.expandedDayIndex = 0});

  TrekDetailLoaded copyWith({
    TrekDetail? detail,
    TrekDetailTab? activeTab,
    int? galleryIndex,
    int? expandedDayIndex,
  }) =>
      TrekDetailLoaded(
        detail: detail ?? this.detail,
        activeTab: activeTab ?? this.activeTab,
        galleryIndex: galleryIndex ?? this.galleryIndex,
        expandedDayIndex: expandedDayIndex ?? this.expandedDayIndex,
      );

  @override
  List<Object?> get props =>
      [detail, activeTab, galleryIndex, expandedDayIndex];
}

class TrekDetailError extends TrekDetailState {
  final String message;

  const TrekDetailError(this.message);
}
