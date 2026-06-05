class ApiConstants{
  static const String baseUrl = "http://192.168.1.103:8081";
  static const String getDestinations = "/api/v1/public/destinations";
  static  String getDestinationsDetails(String id) => "/api/v1/public/destinations/$id/detail";
  static const String getFeaturedTreks = "/api/v1/public/dashboard/popular-destinations";
  static const String getFeaturedCommunityStories = "/api/v1/public/dashboard/popular-stories";
  static const String getCommunityStories = "/api/v1/public/stories";
  static String getStoryDetail(String id) => "/api/v1/public/stories/$id";

  // Strategy endpoints
  static String getStrategies(String destinationId) => "/api/v1/public/destinations/$destinationId/strategies";
  static String getStrategyDetail(String strategyId) => "/api/v1/public/strategies/$strategyId/detail";
  static String getStrategyItineraries(String strategyId) => "/api/v1/public/strategies/$strategyId/itineraries";
  static String getStrategyWaypoints(String strategyId) => "/api/v1/public/strategies/$strategyId/waypoints";
  static String getStrategyPackings(String strategyId) => "/api/v1/public/strategies/$strategyId/packings";
}