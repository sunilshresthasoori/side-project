import '../../service/explore_filter_model.dart';
import '../repository/explore_repository.dart';

class GetDestinations {
  final ExploreRepository repository;
  const GetDestinations(this.repository);

  Future<PaginatedResponse<DestinationResponse>> call(
    FilterRequest request,
  ) {
    return repository.fetchDestinations(request);
  }
}
