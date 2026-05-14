import 'package:equatable/equatable.dart';

class StoryDetail extends Equatable {
  final String id;
  final String title;
  final String excerpt;
  final List<StorySection> sections;
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
  final List<String> tags;
  final List<StoryComment> commentList;
  final List<RelatedStory> relatedStories;

  const StoryDetail({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.sections,
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
    required this.tags,
    required this.commentList,
    required this.relatedStories,
  });

  StoryDetail copyWith({
    String? id,
    String? title,
    String? excerpt,
    List<StorySection>? sections,
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
    List<String>? tags,
    List<StoryComment>? commentList,
    List<RelatedStory>? relatedStories,
  }) {
    return StoryDetail(
      id: id ?? this.id,
      title: title ?? this.title,
      excerpt: excerpt ?? this.excerpt,
      sections: sections ?? this.sections,
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
      tags: tags ?? this.tags,
      commentList: commentList ?? this.commentList,
      relatedStories: relatedStories ?? this.relatedStories,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        excerpt,
        sections,
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
        tags,
        commentList,
        relatedStories,
      ];
}

class StorySection extends Equatable {
  final String heading;
  final List<String> paragraphs;

  const StorySection({required this.heading, required this.paragraphs});

  @override
  List<Object?> get props => [heading, paragraphs];
}

class StoryComment extends Equatable {
  final String id;
  final String authorName;
  final String authorAvatarPath;
  final String text;
  final DateTime date;
  final int likes;
  final bool isLiked;

  const StoryComment({
    required this.id,
    required this.authorName,
    required this.authorAvatarPath,
    required this.text,
    required this.date,
    required this.likes,
    required this.isLiked,
  });

  StoryComment copyWith({
    String? id,
    String? authorName,
    String? authorAvatarPath,
    String? text,
    DateTime? date,
    int? likes,
    bool? isLiked,
  }) {
    return StoryComment(
      id: id ?? this.id,
      authorName: authorName ?? this.authorName,
      authorAvatarPath: authorAvatarPath ?? this.authorAvatarPath,
      text: text ?? this.text,
      date: date ?? this.date,
      likes: likes ?? this.likes,
      isLiked: isLiked ?? this.isLiked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        authorName,
        authorAvatarPath,
        text,
        date,
        likes,
        isLiked,
      ];
}

class RelatedStory extends Equatable {
  final String id;
  final String title;
  final String imagePath;
  final DateTime date;
  final int readTimeMinutes;

  const RelatedStory({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.date,
    required this.readTimeMinutes,
  });

  @override
  List<Object?> get props => [id, title, imagePath, date, readTimeMinutes];
}
