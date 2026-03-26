import 'package:template/core/services/base_service.dart';
import 'package:template/core/models/supplier_response.dart';

class SupplierService extends BaseService {
  Future<SupplierResponse> fetch() async {
    return await get<SupplierResponse> (
      '/v1/suppliers',
      queryParams: {},
      fromJson: (json) => SupplierResponse.fromJson(json),
    );
  }
}