import 'package:template/core/services/base_service.dart';
import 'package:template/modules/home/models/stats_response_model.dart';

class StatsService extends BaseService{
  Future<StatsResponse> fetch() async {
    return await get<StatsResponse>(
      '/v1/analytics/stats',
      fromJson: (json) => StatsResponse.fromJson(json),
    );
  }
}