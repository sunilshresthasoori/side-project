import 'package:trekkers_odyssey_v2/features/explore/service/explore_filter_model.dart';
import '../repository/trek_detail_repository.dart';

class GetTrekDetail {
  final TrekDetailRepository repository;
  const GetTrekDetail(this.repository);

  Future<DestinationDetailResponse> call(String id) {
    return repository.fetchTrekDetail(id);
  }
}
