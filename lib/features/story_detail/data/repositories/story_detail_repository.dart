import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_const.dart';
import '../../domain/models/story_detail_model.dart';

class StoryDetailRepository {
  final http.Client client;

  StoryDetailRepository({http.Client? client})
      : client = client ?? http.Client();

  Future<StoryDetail> fetchStoryDetail(String storyId) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getStoryDetail(storyId)}');
    final response = await client.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load story detail: ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final data = body['data'] as Map<String, dynamic>;
    return StoryDetailMapper.fromJson(data);
  }
}

class StoryDetailMapper {
  static StoryDetail fromJson(Map<String, dynamic> json) {
    final writer = json['writer'] as Map<String, dynamic>? ?? {};
    final destination = json['destination'] as Map<String, dynamic>? ?? {};
    final images = (json['images'] as List? ?? [])
        .map((e) => e as Map<String, dynamic>)
        .toList();

    final imageUrls = images
        .map((img) => img['imageUrl'] as String? ?? '')
        .where((url) => url.isNotEmpty)
        .toList();

    final content = (json['content'] ?? '').toString();
    final completedAt = DateTime.tryParse(json['completedAt']?.toString() ?? '');

    return StoryDetail(
      id: (json['id'] ?? '').toString(),
      title: (json['title'] ?? '').toString(),
      excerpt: (json['shortDescription'] ?? '').toString(),
      sections: [
        StorySection(
          heading: 'Story',
          paragraphs: content.isEmpty ? [] : [content],
        ),
      ],
      authorName: (writer['fullName'] ?? writer['username'] ?? '').toString(),
      authorBio: (writer['bio'] ?? '').toString(),
      authorAvatarPath: (writer['avatar'] ?? '').toString(),
      authorFollowers: (writer['followerCount'] ?? 0) as int,
      imagePath: imageUrls.isNotEmpty ? imageUrls.first : '',
      galleryImagePaths: imageUrls,
      contentType: '', // not provided by API
      difficulty: '',  // not provided by API
      trekName: (destination['destinationName'] ?? '').toString(),
      location: (destination['destinationName'] ?? '').toString(),
      date: completedAt ?? DateTime.now(),
      readTimeMinutes: (json['durationDays'] ?? 0) as int, // optional mapping
      likes: ((json['likeCount'] as Map?)?['totalLikes'] ?? 0) as int,
      comments: 0, // not provided by API
      shares: 0,   // not provided by API
      isBookmarked: false,
      tags: (json['tags'] as List? ?? []).map((e) => '$e').toList(),
      commentList: const [],
      relatedStories: const [],
    );
  }
}