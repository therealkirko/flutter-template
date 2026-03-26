import 'package:template/core/models/response_model.dart';
import 'package:template/core/services/base_service.dart';
import 'package:template/modules/requisitions/models/requisition_response.dart';

class RequisitionService extends BaseService {

  Future<Response> create(dynamic supplier, dynamic branch, items) async {
    var payload = {
      'branch': branch.toString(),
      'supplier': supplier.toString(),
      'items': items,
    };

    return await post<Response> (
      '/v1/requisitions',
      body: payload,
      fromJson: (json) => Response.fromJson(json),
    );
  }

  Future<RequisitionResponse> fetch([String? search, int page = 1, int perPage = 5]) async {
    return await get<RequisitionResponse>(
      '/v1/requisitions',
      queryParams: {
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page.toString(),
        'per_page': perPage.toString(),
      },
      fromJson: (json) => RequisitionResponse.fromJson(json),
    );
  }
}