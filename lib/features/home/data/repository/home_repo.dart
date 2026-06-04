import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trekkers_odyssey_v2/core/constants/api_const.dart';

import '../../domain/models/featured_community_stories_model.dart';
import '../../domain/models/featured_trek_model.dart';
import '../../domain/models/trek_models.dart';

class HomeRepository {
  //  Featured Treks 
  Future<List<FeaturedTrek>> fetchFeaturedTreks() async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getFeaturedTreks}');
    final response =
    await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Server returned ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final list = body['data'] as List;
    return list.map((e) => DestinationApiModel.fromJson(e as Map<String, dynamic>).toFeaturedTrek()).toList();
  }

  //  Community Stories 
  Future<List<CommunityStory>> fetchCommunityStories() async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getFeaturedCommunityStories}');
    final response =
    await http.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode != 200) {
      throw Exception('Server returned ${response.statusCode}');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final list = (body['data'] as List? ?? []);
    return list.map((e) => CommunityStoryApiModel.fromJson(e as Map<String, dynamic>).toCommunityStory()).toList();
  }

  //  Categories
  Future<List<TrekCategory>> fetchCategories() async {
    // TODO:
    return const [
      TrekCategory(
        id: '1',
        title: 'Base Camp',
        subtitle: 'High altitude',
        imagePath: 'assets/images/base_camp.jpg',
      ),
      TrekCategory(
        id: '2',
        title: 'Lakes',
        subtitle: 'Scenic routes',
        imagePath: 'assets/images/lakes.jpg',
      ),
      TrekCategory(
        id: '3',
        title: 'Valleys',
        subtitle: 'Easy trails',
        imagePath: 'assets/images/valley.jpg',
      ),
      TrekCategory(
        id: '4',
        title: 'Passes',
        subtitle: 'Adventure',
        imagePath: 'assets/images/pass.jpg',
      ),
    ];
  }
}