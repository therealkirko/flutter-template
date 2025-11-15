import 'dart:convert';
import 'dart:io';
import 'package:get/get.dart';
import '../config/app_config.dart';
import '../utils/app_exception.dart';
import '../models/error_response_model.dart';
import 'token_service.dart';

/// Base API service for making HTTP requests
/// Modules can extend or use this service for API calls
class ApiService extends GetConnect {
  late final TokenService _tokenService;

  @override
  void onInit() {
    super.onInit();

    // Initialize token service
    _tokenService = Get.find<TokenService>();

    // Configure base URL
    httpClient.baseUrl = AppConfig.baseUrl;

    // Configure timeout
    httpClient.timeout = Duration(seconds: AppConfig.apiTimeout);

    // Add request interceptor
    httpClient.addRequestModifier<dynamic>((request) {
      // Add auth token if available
      final authHeader = _tokenService.getAuthHeader();
      if (authHeader != null) {
        request.headers['Authorization'] = authHeader;
      }

      // Add content type
      request.headers['Content-Type'] = 'application/json';
      request.headers['Accept'] = 'application/json';

      if (AppConfig.enableLogging) {
        print('📤 Request: ${request.method} ${request.url}');
        print('Headers: ${request.headers}');
        if (request.method == 'POST' || request.method == 'PUT') {
          print('Body: ${jsonEncode(request.files)}');
        }
      }

      return request;
    });

    // Add response interceptor
    httpClient.addResponseModifier((request, response) {
      if (AppConfig.enableLogging) {
        print('📥 Response: ${response.statusCode} ${request.url}');
        print('Body: ${response.bodyString}');
      }

      // Handle response based on status code
      _handleResponse(response);

      return response;
    });
  }

  /// Handle HTTP response and throw appropriate exceptions
  void _handleResponse(Response response) {
    switch (response.statusCode) {
      case 200:
      case 201:
      case 204:
        // Success - do nothing
        return;

      case 400:
        final error = _parseError(response);
        throw BadRequestException('error', error);

      case 401:
        final error = _parseError(response);
        throw UnAuthorizedException('error', error);

      case 404:
        final error = _parseError(response);
        throw NotFoundException('error', error);

      case 409:
        final error = _parseError(response);
        throw DuplicateRequestException('error', error);

      case 422:
        final error = _parseDetailedError(response);
        throw ValidationException('error', error);

      case 500:
      case 502:
      case 503:
        final error = _parseError(response);
        throw ServerException('error', error ?? 'Server error occurred');

      default:
        final error = _parseError(response);
        throw AppException('error', error ?? 'An error occurred');
    }
  }

  /// Parse simple error message from response
  String? _parseError(Response response) {
    try {
      if (response.body is Map) {
        final json = response.body as Map<String, dynamic>;
        return json['message'] as String?;
      } else if (response.bodyString != null) {
        final json = jsonDecode(response.bodyString!);
        if (json is Map<String, dynamic>) {
          return json['message'] as String?;
        }
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('Error parsing error message: $e');
      }
    }
    return null;
  }

  /// Parse detailed error message (including validation errors)
  String _parseDetailedError(Response response) {
    try {
      if (response.body is Map) {
        final errorResponse =
            ErrorResponse.fromJson(response.body as Map<String, dynamic>);
        return errorResponse.getDetailedMessage();
      } else if (response.bodyString != null) {
        final json = jsonDecode(response.bodyString!);
        if (json is Map<String, dynamic>) {
          final errorResponse = ErrorResponse.fromJson(json);
          return errorResponse.getDetailedMessage();
        }
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('Error parsing detailed error: $e');
      }
    }
    return 'Validation error occurred';
  }

  /// GET request
  Future<Response<T>> getRequest<T>(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    try {
      return await get<T>(endpoint, query: query);
    } on SocketException {
      throw NetworkException(
        'error',
        'No internet connection. Please check your network.',
      );
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('GET request error: $e');
      }
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
    } on SocketException {
      throw NetworkException(
        'error',
        'No internet connection. Please check your network.',
      );
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('POST request error: $e');
      }
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
    } on SocketException {
      throw NetworkException(
        'error',
        'No internet connection. Please check your network.',
      );
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('PUT request error: $e');
      }
      rethrow;
    }
  }

  /// PATCH request
  Future<Response<T>> patchRequest<T>(
    String endpoint, {
    dynamic body,
  }) async {
    try {
      return await patch<T>(endpoint, body);
    } on SocketException {
      throw NetworkException(
        'error',
        'No internet connection. Please check your network.',
      );
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('PATCH request error: $e');
      }
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
    } on SocketException {
      throw NetworkException(
        'error',
        'No internet connection. Please check your network.',
      );
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('DELETE request error: $e');
      }
      rethrow;
    }
  }
}
