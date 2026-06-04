import 'package:trekkers_odyssey_v2/features/home/domain/models/trek_models.dart';

class CommunityStoryApiModel {
  final int id;
  final String title;
  final String shortDescription;
  final int likeCount;
  final int commentCount;
  final String publishedAt;
  final _Writer writer;
  final _Destination? destination;
  final List<_StoryImage> images;

  const CommunityStoryApiModel({
    required this.id,
    required this.title,
    required this.shortDescription,
    required this.likeCount,
    required this.commentCount,
    required this.publishedAt,
    required this.writer,
    this.destination,
    required this.images,
  });

  factory CommunityStoryApiModel.fromJson(Map<String, dynamic> j) =>
      CommunityStoryApiModel(
        id: j['id'] as int,
        title: j['title'] as String,
        shortDescription: j['shortDescription'] as String,
        likeCount: j['likeCount'] as int,
        commentCount: j['commentCount'] as int,
        publishedAt: j['publishedAt'] as String,
        writer: _Writer.fromJson(j['writer'] as Map<String, dynamic>),
        destination: j['destination'] != null
            ? _Destination.fromJson(j['destination'] as Map<String, dynamic>)
            : null,
        images: (j['images'] as List? ?? [])
            .map((e) => _StoryImage.fromJson(e as Map<String, dynamic>))
            .toList(),
      );

  CommunityStory toCommunityStory() {
    final tag = destination?.destinationName ?? 'Story';

    return CommunityStory(
      id: id.toString(),
      title: title,
      excerpt: shortDescription,
      authorName: writer.fullName,
      authorAvatarPath: writer.avatar ?? '',
      imagePath: images.isNotEmpty ? images.first.imageUrl : '',
      timeAgo: _formatDate(publishedAt),
      likes: likeCount,
      comments: commentCount,
      tags: tag,
    );
  }

  static String _formatDate(String iso) {
    try {
      final date = DateTime.parse(iso);
      final diff = DateTime.now().difference(date);
      if (diff.inDays >= 1) return '${diff.inDays}d ago';
      if (diff.inHours >= 1) return '${diff.inHours}h ago';
      return '${diff.inMinutes}m ago';
    } catch (_) {
      return '';
    }
  }
}

class _Writer {
  final String fullName;
  final String? avatar;

  const _Writer({required this.fullName, this.avatar});

  factory _Writer.fromJson(Map<String, dynamic> j) => _Writer(
    fullName: j['fullName'] as String,
    avatar: j['avatar'] as String?,
  );
}

class _Destination {
  final String destinationName;

  const _Destination({required this.destinationName});

  factory _Destination.fromJson(Map<String, dynamic> j) =>
      _Destination(destinationName: j['destinationName'] as String);
}

class _StoryImage {
  final String imageUrl;

  const _StoryImage({required this.imageUrl});

  factory _StoryImage.fromJson(Map<String, dynamic> j) =>
      _StoryImage(imageUrl: j['imageUrl'] as String);
}