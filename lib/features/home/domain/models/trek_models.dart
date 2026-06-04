import 'dart:ui';

import 'package:equatable/equatable.dart';

class TrekCategory extends Equatable {
  final String id;
  final String title;
  final String subtitle;
  final String imagePath;
  final Color? accentColor;

  const TrekCategory(
      {required this.id,
      required this.title,
      required this.subtitle,
      required this.imagePath,
      this.accentColor});

  @override
  List<Object?> get props => [id];
}

class FeaturedTrek extends Equatable {
  final String id;
  final String name;
  final String district;
  final List<String> imagePaths;
  final int altitudeM;
  final int views;
  final String destinationType;
  final bool isFavourite;
  final double? latitude;
  final double? longitude;

  String get imagePath => imagePaths.isNotEmpty ? imagePaths.first : '';

  const FeaturedTrek({
    required this.id,
    required this.name,
    required this.district,
    required this.imagePaths,
    required this.altitudeM,
    required this.views,
    required this.destinationType,
    required this.isFavourite,
    this.latitude,
    this.longitude,
  });

  FeaturedTrek copyWith({
    String? id,
    String? name,
    String? district,
    List<String>? imagePaths,
    int? altitudeM,
    int? views,
    String? destinationType,
    bool? isFavourite,
    double? latitude,
    double? longitude,
  }) {
    return FeaturedTrek(
      id: id ?? this.id,
      name: name ?? this.name,
      district: district ?? this.district,
      imagePaths: imagePaths ?? this.imagePaths,
      altitudeM: altitudeM ?? this.altitudeM,
      views: views ?? this.views,
      destinationType: destinationType ?? this.destinationType,
      isFavourite: isFavourite ?? this.isFavourite,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }

  @override
  List<Object?> get props => [id];
}

class CommunityStory extends Equatable {
  final String id;
  final String title;
  final String excerpt;
  final String authorName;
  final String authorAvatarPath;
  final String imagePath;
  final String timeAgo;
  final int likes;
  final int comments;
  final String tags;

  const CommunityStory({
    required this.imagePath,
    required this.authorAvatarPath,
    required this.authorName,
    required this.comments,
    required this.excerpt,
    required this.id,
    required this.likes,
    required this.tags,
    required this.timeAgo,
    required this.title,
  });


  @override
  List<Object?> get props => [id];
}
