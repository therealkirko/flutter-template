import 'package:template/core/services/base_service.dart';
import 'package:template/core/models/product_response.dart';

class ProductService extends BaseService {
  Future<ProductResponse> fetch(dynamic supplierId, [String? search, int? page = 1]) async {

    return await get<ProductResponse> (
      '/v1/products',
      queryParams: {
        'supplier': supplierId.toString(),
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page.toString(),
      },
      fromJson: (json) => ProductResponse.fromJson(json),
    );
  }
}