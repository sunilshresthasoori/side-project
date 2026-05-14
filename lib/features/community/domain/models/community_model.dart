import 'package:equatable/equatable.dart';

class CommunityStory extends Equatable {
  final String id;
  final String title;
  final String excerpt;
  final String body;
  final String authorName;
  final String authorBio;
  final String authorAvatarPath;
  final int authorFollowers;
  final String imagePath;
  final List<String> galleryImagePaths;
  final String contentType;
  final String difficulty;
  final String trekName;
  final String location;
  final DateTime date;
  final int readTimeMinutes;
  final int likes;
  final int comments;
  final int shares;
  final bool isBookmarked;
  final bool isFeatured;
  final List<String> tags;

  const CommunityStory({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.body,
    required this.authorName,
    required this.authorBio,
    required this.authorAvatarPath,
    required this.authorFollowers,
    required this.imagePath,
    required this.galleryImagePaths,
    required this.contentType,
    required this.difficulty,
    required this.trekName,
    required this.location,
    required this.date,
    required this.readTimeMinutes,
    required this.likes,
    required this.comments,
    required this.shares,
    required this.isBookmarked,
    required this.isFeatured,
    required this.tags,
  });

  CommunityStory copyWith({
    String? id,
    String? title,
    String? excerpt,
    String? body,
    String? authorName,
    String? authorBio,
    String? authorAvatarPath,
    int? authorFollowers,
    String? imagePath,
    List<String>? galleryImagePaths,
    String? contentType,
    String? difficulty,
    String? trekName,
    String? location,
    DateTime? date,
    int? readTimeMinutes,
    int? likes,
    int? comments,
    int? shares,
    bool? isBookmarked,
    bool? isFeatured,
    List<String>? tags,
  }) {
    return CommunityStory(
      id: id ?? this.id,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      body: body ?? this.body,
      authorName: authorName ?? this.authorName,
      authorBio: authorBio ?? this.authorBio,
      authorAvatarPath: authorAvatarPath ?? this.authorAvatarPath,
      authorFollowers: authorFollowers ?? this.authorFollowers,
      imagePath: imagePath ?? this.imagePath,
      galleryImagePaths: galleryImagePaths ?? this.galleryImagePaths,
      contentType: contentType ?? this.contentType,
      difficulty: difficulty ?? this.difficulty,
      trekName: trekName ?? this.trekName,
      location: location ?? this.location,
      date: date ?? this.date,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      shares: shares ?? this.shares,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      isFeatured: isFeatured ?? this.isFeatured,
      tags: tags ?? this.tags,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        excerpt,
        body,
        authorName,
        authorBio,
        authorAvatarPath,
        authorFollowers,
        imagePath,
        galleryImagePaths,
        contentType,
        difficulty,
        trekName,
        location,
        date,
        readTimeMinutes,
        likes,
        comments,
        shares,
        isBookmarked,
        isFeatured,
        tags,
      ];
}

class CommunityFilters extends Equatable {
  final String? location;
  final String? difficulty;
  final String? contentType;
  final String? sortBy;

  const CommunityFilters({
    this.location,
    this.difficulty,
    this.contentType,
    this.sortBy,
  });

  CommunityFilters copyWith({
    String? location,
    String? difficulty,
    String? contentType,
    String? sortBy,
  }) {
    return CommunityFilters(
      location: location ?? this.location,
      difficulty: difficulty ?? this.difficulty,
      contentType: contentType ?? this.contentType,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  @override
  List<Object?> get props => [location, difficulty, contentType, sortBy];
}
