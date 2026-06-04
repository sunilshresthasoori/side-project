import '../../service/explore_filter_model.dart';

abstract class ExploreRepository {
  Future<PaginatedResponse<DestinationResponse>> fetchDestinations(
    FilterRequest request,
  );
}
