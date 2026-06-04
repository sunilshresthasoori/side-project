import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:trekkers_odyssey_v2/core/constants/api_const.dart';

import '../../../explore/service/explore_filter_model.dart';
import '../../service/api_response_wrapper.dart';

class TrekDetailRemoteRepository {

  final http.Client client;
  final String baseUrl;

  TrekDetailRemoteRepository({http.Client? client, String? baseUrl})
      : client = client ?? http.Client(),
        baseUrl = baseUrl ?? ApiConstants.baseUrl;

  Future<DestinationDetailResponse> fetchDestinationDetail(String id) async {
    final response =
    await client.get(Uri.parse('$baseUrl/destinations/$id/detail'));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load destination detail');
    }

    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final wrapped = ApiResponse.fromJson(
      body,
          (data) => DestinationDetailResponse.fromJson(data),
    );
    return wrapped.data;
  }
}