part of 'trek_detail_bloc.dart';

abstract class TrekDetailEvent extends Equatable{
  const TrekDetailEvent();

  @override
  List<Object?> get props => [];

}

class TrekDetailFetchEvent extends TrekDetailEvent{
  final String trekId;

  const TrekDetailFetchEvent(this.trekId);

  @override
  List<Object?> get props => [trekId];
}

// User tapped a tab in the sticky tab bar
///CHEKC later
class TrekDetailTabChangedEvent extends TrekDetailEvent {
  final TrekDetailTab tab;
  const TrekDetailTabChangedEvent(this.tab);
  @override
  List<Object?> get props => [tab];
}

//user swipes the image
class TrekDetailGalleryChangedEvent extends TrekDetailEvent{
  final int index;

  const TrekDetailGalleryChangedEvent(this.index);

  @override
  List<Object?> get props => [index];
}


//user taps bookmark event
class TrekDetailSaveToggledEvent extends TrekDetailEvent {

  const TrekDetailSaveToggledEvent();
}


//user taps itenary day


class TrekDetailItineraryDayTappedEvent extends TrekDetailEvent{
  final int dayIndex;

  const TrekDetailItineraryDayTappedEvent(this.dayIndex);

  @override
  List<Object?> get props => [dayIndex];
}


