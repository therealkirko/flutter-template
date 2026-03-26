import 'package:template/core/services/base_service.dart';
import 'package:template/modules/delivery/models/order_response.dart';

class OrderService extends BaseService {
  Future<OrderResponse> fetch(int page, dynamic branch) async {

    return await get<OrderResponse> (
      '/v1/orders',
      queryParams: {
        if (branch != null) 'branch': branch.toString(),
        'page': page.toString(),
      },
      fromJson: (json) => OrderResponse.fromJson(json),
    );
  }
}