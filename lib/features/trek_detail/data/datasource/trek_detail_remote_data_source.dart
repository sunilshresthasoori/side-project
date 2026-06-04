import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:trekkers_odyssey_v2/core/constants/api_const.dart';
import 'package:trekkers_odyssey_v2/features/explore/service/explore_filter_model.dart';

class TrekDetailRemoteDataSource {
  final http.Client client;

  TrekDetailRemoteDataSource({http.Client? client, String? baseUrl})
      : client = client ?? http.Client();

  Future<DestinationDetailResponse> fetchTrekDetail(String id) async {
    final response = await client.get(
      Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getDestinationsDetails(id)}'),
    );

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

// Wrapper for endpoints that return { message, httpStatus, data, errorCode }.
class ApiResponse<T> {
  final String message;
  final String httpStatus;
  final T data;
  final String? errorCode;

  const ApiResponse({
    required this.message,
    required this.httpStatus,
    required this.data,
    this.errorCode,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) fromJsonT,
  ) {
    return ApiResponse(
      message: json['message'] ?? '',
      httpStatus: json['httpStatus'] ?? '',
      errorCode: json['errorCode'],
      data: fromJsonT(json['data'] as Map<String, dynamic>),
    );
  }
}
