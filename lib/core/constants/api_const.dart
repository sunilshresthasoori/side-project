class ApiConstants{
  static const String baseUrl = "http://192.168.1.103:8081";
  static const String getDestinations = "/api/v1/public/destinations";
  static  String getDestinationsDetails(String id) => "/api/v1/public/destinations/$id/detail";
  static const String getFeaturedTreks = "/api/v1/public/dashboard/popular-destinations";
  static const String getFeaturedCommunityStories = "/api/v1/public/dashboard/popular-stories";
  static const String getCommunityStories = "/api/v1/public/stories";
  static String getStoryDetail(String id) => "/api/v1/public/stories/$id";

}