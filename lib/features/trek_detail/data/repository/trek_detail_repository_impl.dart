import 'package:trekkers_odyssey_v2/features/explore/service/explore_filter_model.dart';
import '../datasource/trek_detail_remote_data_source.dart';
import '../../domain/repository/trek_detail_repository.dart';

class TrekDetailRepositoryImpl implements TrekDetailRepository {
  final TrekDetailRemoteDataSource remote;

  TrekDetailRepositoryImpl({TrekDetailRemoteDataSource? remote})
      : remote = remote ?? TrekDetailRemoteDataSource();

  @override
  Future<DestinationDetailResponse> fetchTrekDetail(String id) {
    return remote.fetchTrekDetail(id);
  }
}
