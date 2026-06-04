import 'package:trekkers_odyssey_v2/features/explore/service/explore_filter_model.dart';

abstract class TrekDetailRepository {
  Future<DestinationDetailResponse> fetchTrekDetail(String id);
}
