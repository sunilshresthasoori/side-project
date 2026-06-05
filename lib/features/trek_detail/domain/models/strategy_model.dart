import 'package:equatable/equatable.dart';

// STRATEGY (from list)
class Strategy extends Equatable {
  final int id;
  final String name;
  final String routeType;
  final String totalDays;
  final String totalDistance;

  const Strategy({
    required this.id,
    required this.name,
    required this.routeType,
    required this.totalDays,
    required this.totalDistance,
  });

  @override
  List<Object?> get props => [id, name];
}

// STRATEGY DETAIL
class StrategyDetail extends Equatable {
  final int id;
  final String name;
  final String routeType;
  final int totalDays;
  final double totalDistance;
  final int highestPoint;
  final int maxAltitude;
  final String aboutTrek;
  final String difficultyAdjustment;
  final String accessCity;
  final int acclimatizationDays;
  final List<String> highlights;

  const StrategyDetail({
    required this.id,
    required this.name,
    required this.routeType,
    required this.totalDays,
    required this.totalDistance,
    required this.highestPoint,
    required this.maxAltitude,
    required this.aboutTrek,
    required this.difficultyAdjustment,
    required this.accessCity,
    required this.acclimatizationDays,
    required this.highlights,
  });

  @override
  List<Object?> get props => [id, name];
}

// ITINERARY
class StrategyItinerary extends Equatable {
  final int dayNumber;
  final String startPoint;
  final String endPoint;
  final String duration;
  final int temperature;
  final int altitudeGain;
  final int altitudeLoss;
  final String description;
  final String trekDetails;

  const StrategyItinerary({
    required this.dayNumber,
    required this.startPoint,
    required this.endPoint,
    required this.duration,
    required this.temperature,
    required this.altitudeGain,
    required this.altitudeLoss,
    required this.description,
    required this.trekDetails,
  });

  @override
  List<Object?> get props => [dayNumber];
}

// WAYPOINT (route progression)
class StrategyWaypoint extends Equatable {
  final int order;
  final String name;
  final int altitude;
  final String type;
  final String description;
  final String? imageUrl;

  const StrategyWaypoint({
    required this.order,
    required this.name,
    required this.altitude,
    required this.type,
    required this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [order, name];
}

// PACKING
class StrategyPacking extends Equatable {
  final String profileName;
  final List<String> items;

  const StrategyPacking({
    required this.profileName,
    required this.items,
  });

  @override
  List<Object?> get props => [profileName];
}

