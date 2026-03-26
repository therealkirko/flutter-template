import 'package:template/core/models/response_model.dart';
import 'package:template/core/services/base_service.dart';

class DeliveryService extends BaseService {
  Future<Response> create (dynamic payload) async {
    return await post<Response> (
      '/v1/deliveries',
      body: payload,
      fromJson: (json) => Response.fromJson(json),
    );
  }
}