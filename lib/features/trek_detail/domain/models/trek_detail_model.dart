import 'package:equatable/equatable.dart';

class RoutePoint extends Equatable {
  final int stepNumber;
  final String name;
  final int altitudeM;
  final String description;

  const RoutePoint({
    required this.stepNumber,
    required this.name,
    required this.altitudeM,
    required this.description,
  });

  @override
  List<Object?> get props => [stepNumber, name];
}

//  ITINERARY DAY
class ItineraryCheckpoint extends Equatable {
  final String name;
  final String description;
  final int altitudeM;
  final String tempMin;
  final String tempMax;
  final bool hasWifi;
  final bool hasAtm;
  final bool hasCharging;

  const ItineraryCheckpoint({
    required this.name,
    required this.description,
    required this.altitudeM,
    required this.tempMin,
    required this.tempMax,
    this.hasWifi = false,
    this.hasAtm = false,
    this.hasCharging = false,
  });

  @override
  List<Object?> get props => [name, altitudeM];
}

class ItineraryDay extends Equatable {
  final int dayNumber;
  final String title;
  final String subtitle;
  final int durationHours;
  final int distanceKm;
  final int altitudeM;
  final String description;
  final List<ItineraryCheckpoint> checkpoints;

  const ItineraryDay({
    required this.dayNumber,
    required this.title,
    required this.subtitle,
    required this.durationHours,
    required this.distanceKm,
    required this.altitudeM,
    required this.description,
    required this.checkpoints,
  });

  @override
  List<Object?> get props => [dayNumber];
}

//  TEAHOUSE / HOTEL

class TrekHotel extends Equatable {
  final String id;
  final String name;
  final String location;
  final String imagePath;
  final double rating;
  final int priceMinUSD;
  final int priceMaxUSD;
  final bool isVerified;
  final List<String>
      amenities; // 'WiFi','Hot Shower','Restaurant','Heating','ATM','Monastery View'

  const TrekHotel({
    required this.id,
    required this.name,
    required this.location,
    required this.imagePath,
    required this.rating,
    required this.priceMinUSD,
    required this.priceMaxUSD,
    required this.amenities,
    this.isVerified = true,
  });

  @override
  List<Object?> get props => [id];
}

//  REVIEW

class TrekReview extends Equatable {
  final String id;
  final String authorName;
  final String authorAvatarPath;
  final String timeAgo;
  final bool isVerified;
  final double overallRating;
  final double difficultyRating;
  final double sceneryRating;
  final double accommodationRating;
  final double safetyRating;
  final String body;
  final List<String> photosPaths; // reviewer photos
  final int helpfulCount;

  const TrekReview({
    required this.id,
    required this.authorName,
    required this.authorAvatarPath,
    required this.timeAgo,
    required this.overallRating,
    required this.difficultyRating,
    required this.sceneryRating,
    required this.accommodationRating,
    required this.safetyRating,
    required this.body,
    required this.helpfulCount,
    this.isVerified = true,
    this.photosPaths = const [],
  });

  @override
  List<Object?> get props => [id];
}

//  RATING SUMMARY

class RatingSummary extends Equatable {
  final double overall;
  final int totalReviews;
  final double difficulty;
  final double scenery;
  final double accommodation;
  final double safety;

  const RatingSummary({
    required this.overall,
    required this.totalReviews,
    required this.difficulty,
    required this.scenery,
    required this.accommodation,
    required this.safety,
  });

  @override
  List<Object?> get props => [overall, totalReviews];
}

//  PERMIT

class TrekPermit extends Equatable {
  final String name;
  final String description;
  final int priceNPR;
  final int priceUSD;

  const TrekPermit({
    required this.name,
    required this.description,
    required this.priceNPR,
    required this.priceUSD,
  });

  @override
  List<Object?> get props => [name];
}

//  PACKING CATEGORY

class PackingCategory extends Equatable {
  final String title;
  final List<String> items;

  const PackingCategory({required this.title, required this.items});

  @override
  List<Object?> get props => [title];
}

//  FULL TREK DETAIL

class TrekDetail extends Equatable {
  final String id;
  final String title;
  final String region;
  final String country;
  final List<String> galleryImages; // assets/images/
  final List<String> galleryCaptions;
  final String aboutText;
  final String difficulty;
  final int durationDays;
  final int distanceKm;
  final int maxAltitudeM;
  final String bestSeason;
  final double priceNPR;
  final RatingSummary ratingSummary;
  final List<RoutePoint> routePoints;
  final List<ItineraryDay> itinerary;
  final List<TrekHotel> hotels;
  final List<TrekReview> reviews;
  final List<TrekPermit> permits;
  final List<PackingCategory> packingList;
  final bool isSaved;

  const TrekDetail({
    required this.id,
    required this.title,
    required this.region,
    required this.country,
    required this.galleryImages,
    required this.galleryCaptions,
    required this.aboutText,
    required this.difficulty,
    required this.durationDays,
    required this.distanceKm,
    required this.maxAltitudeM,
    required this.bestSeason,
    required this.priceNPR,
    required this.ratingSummary,
    required this.routePoints,
    required this.itinerary,
    required this.hotels,
    required this.reviews,
    required this.permits,
    required this.packingList,
    this.isSaved = false,
  });

  @override
  List<Object?> get props => [id, isSaved];
}
