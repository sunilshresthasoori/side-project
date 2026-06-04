import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trekkers_odyssey_v2/core/constants/api_const.dart';
import '../../domain/repository/explore_repository.dart';
import '../../service/explore_filter_model.dart';

class ExploreRemoteDataSource {
  final http.Client client;

  ExploreRemoteDataSource({http.Client? client, String? baseUrl})
      : client = client ?? http.Client();

  Future<PaginatedResponse<DestinationResponse>> fetchDestinations(
    FilterRequest request,
  ) async {
    final response = await client.post(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getDestinations}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load destinations');
    }

    return PaginatedResponse.fromJson(
      jsonDecode(response.body) as Map<String, dynamic>,
      (json) => DestinationResponse.fromJson(json),
    );
  }
}

class ExploreRemoteRepository implements ExploreRepository {
  final ExploreRemoteDataSource remote;

  ExploreRemoteRepository({ExploreRemoteDataSource? remote})
      : remote = remote ?? ExploreRemoteDataSource();

  @override
  Future<PaginatedResponse<DestinationResponse>> fetchDestinations(
    FilterRequest request,
  ) {
    return remote.fetchDestinations(request);
  }
}
