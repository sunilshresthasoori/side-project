import 'package:trekkers_odyssey_v2/features/home/domain/models/trek_models.dart';

class DestinationImage {
  final String imageUrl;

  const DestinationImage({required this.imageUrl});

  factory DestinationImage.fromJson(Map<String, dynamic> j) =>
      DestinationImage(imageUrl: j['imageUrl'] as String);
}

class DestinationApiModel {
  final int id;
  final String name;
  final String district;
  final String altitude;
  final String destinationType;
  final int views;
  final List<DestinationImage> images;
  final String? latitude;
  final String? longitude;

  const DestinationApiModel({
    required this.id,
    required this.name,
    required this.district,
    required this.altitude,
    required this.destinationType,
    required this.views,
    required this.images,
    this.latitude,
    this.longitude,
  });

  factory DestinationApiModel.fromJson(Map<String, dynamic> j) =>
      DestinationApiModel(
        id: j['id'] as int,
        name: j['name'] as String,
        district: j['district'] as String,
        altitude: j['altitude'] as String,
        destinationType: j['destinationType'] as String,
        views: j['views'] as int,
        images: (j['images'] as List)
            .map((e) => DestinationImage.fromJson(e as Map<String, dynamic>))
            .toList(),
        latitude: j['latitude'] as String?,
        longitude: j['longitude'] as String?,
      );

  /// Maps API fields → FeaturedTrek used by the UI
  FeaturedTrek toFeaturedTrek() => FeaturedTrek(
        id: id.toString(),
        name: name,
        district: district,
        imagePaths: images.map((i) => i.imageUrl).toList(),
        // durationDays: 0,
        // not in API
        altitudeM: int.tryParse(altitude) ?? 0,
        // priceNpr: 0,
        // not in API
        // rating: 0,
        // not in API
        views: views,
        destinationType: _mapType(destinationType),
        isFavourite: false,
        latitude: double.tryParse(latitude ?? ''),
        longitude: double.tryParse(longitude ?? ''),
      );

  static String _mapType(String type) => switch (type) {
        'BASE_CAMP' => 'Hard',
        'LAKE' => 'Moderate',
        'VALLEY' => 'Easy',
        _ => type,
      };
}
