import 'package:equatable/equatable.dart';

class CommunityStory extends Equatable {
  final String id;
  final String title;
  final String shortDescription;
  final String body;
  final String fullName;
  final String bio;
  final String avatar;
  final int followerCount;
  final String imagePath;
  final List<String> galleryImagePaths;
  final String contentType;
  final String difficulty;
  final String trekName;
  final String destinationName;
  final DateTime publishedAt;
  final int readTimeMinutes;
  final int likeCount;
  final int commentCount;
  final int shares;
  final bool isBookmarked;
  final bool isFeatured;
  final List<String> tags;

  const CommunityStory({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.body,
    required this.fullName,
    required this.bio,
    required this.avatar,
    required this.followerCount,
    required this.imagePath,
    required this.galleryImagePaths,
    required this.contentType,
    required this.difficulty,
    required this.trekName,
    required this.destinationName,
    required this.publishedAt,
    required this.readTimeMinutes,
    required this.likeCount,
    required this.commentCount,
    required this.shares,
    required this.isBookmarked,
    required this.isFeatured,
    required this.tags,
  });

  factory CommunityStory.fromJson(Map<String, dynamic> json) {
    final writer = json['writer'] as Map<String, dynamic>? ?? {};
    final images = (json['images'] as List<dynamic>?) ?? [];
    final destination = json['destination'] as Map<String, dynamic>? ?? {};

    return CommunityStory(
      id: json['id'].toString(),
      title: json['title'] as String? ?? '',
      shortDescription: json['shortDescription'] as String? ?? '',
      body: '',
      fullName: writer['fullName'] as String? ?? writer['username'] as String? ?? '',
      bio: writer['bio'] as String? ?? '',
      avatar: writer['avatar'] as String? ?? '',
      followerCount: (writer['followerCount'] as num?)?.toInt() ?? 0,
      imagePath: images.isNotEmpty ? (images[0]['imageUrl'] as String? ?? '') : '',
      galleryImagePaths: images
          .map((img) => img['imageUrl'] as String? ?? '')
          .where((url) => url.isNotEmpty)
          .toList(),
      contentType: '',
      difficulty: '',
      trekName: '',
      destinationName: destination['destinationName'] as String? ?? '',
      publishedAt: DateTime.tryParse(json['publishedAt'] as String? ?? '') ?? DateTime.now(),
      readTimeMinutes: 0, // not in API
      likeCount: (json['likeCount'] as num?)?.toInt() ?? 0,
      commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
      shares: 0, // not in API
      isBookmarked: false, // not in API
      isFeatured: false, // not in API
      tags: const [], // not in API
    );
  }

  CommunityStory copyWith({
    String? id,
    String? title,
    String? shortDescription,
    String? body,
    String? fullName,
    String? bio,
    String? avatar,
    int? followerCount,
    String? imagePath,
    List<String>? galleryImagePaths,
    String? contentType,
    String? difficulty,
    String? trekName,
    String? destinationName,
    DateTime? publishedAt,
    int? readTimeMinutes,
    int? likeCount,
    int? commentCount,
    int? shares,
    bool? isBookmarked,
    bool? isFeatured,
    List<String>? tags,
  }) {
    return CommunityStory(
      id: id ?? this.id,
      title: title ?? this.title,
      shortDescription: shortDescription ?? this.shortDescription,
      body: body ?? this.body,
      fullName: fullName ?? this.fullName,
      bio: bio ?? this.bio,
      avatar: avatar ?? this.avatar,
      followerCount: followerCount ?? this.followerCount,
      imagePath: imagePath ?? this.imagePath,
      galleryImagePaths: galleryImagePaths ?? this.galleryImagePaths,
      contentType: contentType ?? this.contentType,
      difficulty: difficulty ?? this.difficulty,
      trekName: trekName ?? this.trekName,
      destinationName: destinationName ?? this.destinationName,
      publishedAt: publishedAt ?? this.publishedAt,
      readTimeMinutes: readTimeMinutes ?? this.readTimeMinutes,
      likeCount: likeCount ?? this.likeCount,
      commentCount: commentCount ?? this.commentCount,
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
    shortDescription,
    body,
    fullName,
    bio,
    avatar,
    followerCount,
    imagePath,
    galleryImagePaths,
    contentType,
    difficulty,
    trekName,
    destinationName,
    publishedAt,
    readTimeMinutes,
    likeCount,
    commentCount,
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