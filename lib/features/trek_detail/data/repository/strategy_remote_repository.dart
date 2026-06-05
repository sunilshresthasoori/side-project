import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../core/constants/api_const.dart';
import '../../domain/models/strategy_model.dart';

class StrategyRemoteDataSource {
  final http.Client client;

  StrategyRemoteDataSource({http.Client? client}) : client = client ?? http.Client();

  Future<List<Strategy>> fetchStrategies(String destinationId) async {
    final uri = Uri.parse('${ApiConstants.baseUrl}${ApiConstants.getStrategies(destinationId)}');
    final response = await client.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load strategies');
    }

    final list = jsonDecode(response.body) as List;
    return list.map((e) => StrategyMapper.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<StrategyDetail> fetchStrategyDetail(int strategyId) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getStrategyDetail(strategyId.toString())}');
    final response = await client.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load strategy detail');
    }

    final json = jsonDecode(response.body) as Map<String, dynamic>;
    return StrategyDetailMapper.fromJson(json);
  }

  Future<List<StrategyItinerary>> fetchItineraries(int strategyId) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getStrategyItineraries(strategyId.toString())}');
    final response = await client.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load itineraries');
    }

    final list = jsonDecode(response.body) as List;
    return list
        .map((e) => StrategyItineraryMapper.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<StrategyWaypoint>> fetchWaypoints(int strategyId) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getStrategyWaypoints(strategyId.toString())}');
    final response = await client.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load waypoints');
    }

    final list = jsonDecode(response.body) as List;
    return list.map((e) => StrategyWaypointMapper.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<StrategyPacking>> fetchPackings(int strategyId) async {
    final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.getStrategyPackings(strategyId.toString())}');
    final response = await client.get(uri).timeout(const Duration(seconds: 10));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw Exception('Failed to load packings');
    }

    final list = jsonDecode(response.body) as List;
    return list.map((e) => StrategyPackingMapper.fromJson(e as Map<String, dynamic>)).toList();
  }
}

// MAPPERS

class StrategyMapper {
  static Strategy fromJson(Map<String, dynamic> json) {
    return Strategy(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      routeType: json['routeType'] as String? ?? '',
      totalDays: json['totalDays']?.toString() ?? '0',
      totalDistance: json['totalDistance']?.toString() ?? '0',
    );
  }
}

class StrategyDetailMapper {
  static StrategyDetail fromJson(Map<String, dynamic> json) {
    return StrategyDetail(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      routeType: json['routeType'] as String? ?? '',
      totalDays: json['totalDays'] as int? ?? 0,
      totalDistance: (json['totalDistance'] as num?)?.toDouble() ?? 0.0,
      highestPoint: json['highestPoint'] as int? ?? 0,
      maxAltitude: json['maxAltitude'] as int? ?? 0,
      aboutTrek: json['aboutTrek'] as String? ?? '',
      difficultyAdjustment: json['difficultyAdjustment'] as String? ?? '',
      accessCity: json['accessCity'] as String? ?? '',
      acclimatizationDays: json['acclimatizationDays'] as int? ?? 0,
      highlights: (json['highlights'] as List? ?? []).map((e) => '$e').toList(),
    );
  }
}

class StrategyItineraryMapper {
  static StrategyItinerary fromJson(Map<String, dynamic> json) {
    return StrategyItinerary(
      dayNumber: json['dayNumber'] as int? ?? 0,
      startPoint: json['startPoint'] as String? ?? '',
      endPoint: json['endPoint'] as String? ?? '',
      duration: json['duration']?.toString() ?? '0h',
      temperature: json['temperature'] as int? ?? 0,
      altitudeGain: json['altitudeGain'] as int? ?? 0,
      altitudeLoss: json['altitudeLoss'] as int? ?? 0,
      description: json['description'] as String? ?? '',
      trekDetails: json['trekDetails'] as String? ?? '',
    );
  }
}

class StrategyWaypointMapper {
  static StrategyWaypoint fromJson(Map<String, dynamic> json) {
    return StrategyWaypoint(
      order: json['order'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      altitude: json['altitude'] as int? ?? 0,
      type: json['type'] as String? ?? '',
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
    );
  }
}

class StrategyPackingMapper {
  static StrategyPacking fromJson(Map<String, dynamic> json) {
    return StrategyPacking(
      profileName: json['profileName'] as String? ?? '',
      items: (json['items'] as List? ?? []).map((e) => '$e').toList(),
    );
  }
}

