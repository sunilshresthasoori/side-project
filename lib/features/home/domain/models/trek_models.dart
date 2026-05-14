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
  final String title;
  final String region;
  final String imagePath;
  final int durationDays;
  final int altitudeM;
  final double priceNpr;
  final double rating;
  final int reviewCount;
  final String difficulty;
  final bool isFavourite;

  const FeaturedTrek({
    required this.id,
    required this.title,
    required this.region,
    required this.imagePath,
    required this.durationDays,
    required this.altitudeM,
    required this.priceNpr,
    required this.rating,
    required this.reviewCount,
    required this.difficulty,
    required this.isFavourite,
  });

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
