import 'dart:convert';
import 'package:get/get.dart';
import '../config/app_config.dart';

/// Base API service for making HTTP requests
/// Modules can extend or use this service for API calls
class ApiService extends GetConnect {
  @override
  void onInit() {
    super.onInit();

    // Configure base URL
    httpClient.baseUrl = AppConfig.baseUrl;

    // Configure timeout
    httpClient.timeout = Duration(seconds: AppConfig.apiTimeout);

    // Add request interceptor
    httpClient.addRequestModifier<dynamic>((request) {
      // Add auth token if available
      final token = _getAuthToken();
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }

      // Add content type
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';

      if (AppConfig.enableLogging) {
        print('Request: ${request.method} ${request.url}');
      }

      return request;
    });

    // Add response interceptor
    httpClient.addResponseModifier((request, response) {
      if (AppConfig.enableLogging) {
        print('Response: ${response.statusCode} ${request.url}');
      }
      return response;
    });
  }

  /// GET request
  Future<Response<T>> getRequest<T>(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    try {
      return await get<T>(endpoint, query: query);
    } catch (e) {
      rethrow;
    }
  }

  /// POST request
  Future<Response<T>> postRequest<T>(
    String endpoint, {
    dynamic body,
  }) async {
    try {
      return await post<T>(endpoint, body);
    } catch (e) {
      rethrow;
    }
  }

  /// PUT request
  Future<Response<T>> putRequest<T>(
    String endpoint, {
    dynamic body,
  }) async {
    try {
      return await put<T>(endpoint, body);
    } catch (e) {
      rethrow;
    }
  }

  /// DELETE request
  Future<Response<T>> deleteRequest<T>(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    try {
      return await delete<T>(endpoint, query: query);
    } catch (e) {
      rethrow;
    }
  }

  /// Get auth token from storage
  /// Override this method in your implementation
  String? _getAuthToken() {
    // TODO: Implement token retrieval from local storage
    // Example: return Get.find<StorageService>().getToken();
    return null;
  }
}
