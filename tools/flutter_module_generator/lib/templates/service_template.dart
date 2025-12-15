class ServiceTemplate {
  static String generate(String moduleName, String className, String modelClass) {
    return '''import 'package:get/get.dart';
import '../../../core/services/base_service.dart';
import '../models/$moduleName\_model.dart';

/// $className
/// Handles all API calls for $moduleName module
class $className extends BaseService {
  /// Get all items
  ///
  /// Returns: List of items
  Future<List<$modelClass>> getAll({
    int page = 1,
    int perPage = 20,
  }) async {
    final response = await get(
      '/${moduleName}s',
      query: {
        'page': page,
        'per_page': perPage,
      },
    );

    final data = extractData<List>(response, 'data');
    return data?.map((json) => $modelClass.fromJson(json)).toList() ?? [];
  }

  /// Get item by ID
  ///
  /// Returns: Single item
  Future<$modelClass> getById(String id) async {
    final response = await get('/${moduleName}s/\$id');

    return $modelClass.fromJson(response.body);
  }

  /// Create new item
  ///
  /// Returns: Created item
  Future<$modelClass> create({
    required Map<String, dynamic> data,
  }) async {
    final response = await post(
      '/${moduleName}s',
      body: data,
    );

    return $modelClass.fromJson(response.body);
  }

  /// Update item
  ///
  /// Returns: Updated item
  Future<$modelClass> update({
    required String id,
    required Map<String, dynamic> data,
  }) async {
    final response = await put(
      '/${moduleName}s/\$id',
      body: data,
    );

    return $modelClass.fromJson(response.body);
  }

  /// Delete item
  ///
  /// Returns: void
  Future<void> delete(String id) async {
    await this.delete('/${moduleName}s/\$id');
  }
}
''';
  }
}
