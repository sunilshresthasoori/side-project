import 'package:trekkers_odyssey_v2/features/explore/service/explore_filter_model.dart';
import '../../domain/models/trek_detail_model.dart';

class TrekDetailMapper {
  static TrekDetail fromApi(
    DestinationDetailResponse dto, {
    required TrekDetail fallback,
  }) {
    final sortedImages = [...dto.images]
      ..sort((a, b) => (a.displayOrder ?? 0).compareTo(b.displayOrder ?? 0));

    final galleryImages = sortedImages
        .map((e) => e.imageUrl)
        .where((e) => e.trim().isNotEmpty)
        .toList();

    final galleryCaptions = sortedImages
        .map((e) => e.description ?? e.altMessage ?? dto.name)
        .toList();

    final altitudeValue = int.tryParse(
          (dto.altitude ?? '').replaceAll(RegExp(r'[^0-9]'), ''),
        ) ??
        fallback.maxAltitudeM;

    return TrekDetail(
      id: dto.id.toString(),
      title: dto.name,
      region: dto.region ?? dto.district ?? dto.province ?? '',
      country: 'Nepal',
      galleryImages:
          galleryImages.isNotEmpty ? galleryImages : fallback.galleryImages,
      galleryCaptions: galleryCaptions.isNotEmpty
          ? galleryCaptions
          : fallback.galleryCaptions,
      aboutText: dto.description ?? fallback.aboutText,
      difficulty: fallback.difficulty,
      durationDays: fallback.durationDays,
      distanceKm: fallback.distanceKm,
      maxAltitudeM: altitudeValue,
      bestSeason: fallback.bestSeason,
      priceNPR: fallback.priceNPR,
      ratingSummary: fallback.ratingSummary,
      routePoints: fallback.routePoints,
      itinerary: fallback.itinerary,
      hotels: fallback.hotels,
      reviews: fallback.reviews,
      permits: fallback.permits,
      packingList: fallback.packingList,
      isSaved: fallback.isSaved,
    );
  }
}
