import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trekkers_odyssey_v2/core/constants/api_const.dart';
import 'package:trekkers_odyssey_v2/features/community/domain/models/community_model.dart';


class CommunityRepository {
  Future<List<CommunityStory>> fetchStories({
    String search = '',
    String? location,
    String? difficulty,
    String? sortBy,
    int page = 0,
    int size = 20,
  }) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getCommunityStories}');
    final filters = <Map<String, String>>[];
    if (location != null) filters.add({'key': 'location', 'value': location});
    if (difficulty != null) filters.add({'key': 'difficulty', 'value': difficulty});

    final pagination = <String, dynamic>{
      'size': size,
      'page': page,
    };

    if (sortBy != null && sortBy.isNotEmpty) {
      pagination['sortBy'] = sortBy;
    }

    final body = jsonEncode({
      'filterCriteriaRequests': filters,
      'paginationRequest': pagination,
      'search': search,
    });

    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to load stories: ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    final data = json['data'] as List<dynamic>;
    return data
        .map((item) => CommunityStory.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  // TODO: keeping these for filter dropdowns or fetch from API if endpoints exist
  List<String> getLocations() => [];
  List<String> getDifficulties() => [];
  List<String> getContentTypes() => [];
}
