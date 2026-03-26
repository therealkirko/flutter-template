import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:template/core/utils/storage_utility.dart';
import 'package:template/core/models/response_model.dart';
import 'package:template/core/utils/exception_utility.dart';

abstract class BaseService {
  // Base configuration
  static const String baseUrl = 'https://mavazi.chara.ke/api';
  static String _token = '';

  // Storage instance
  final StorageUtility _storage = StorageUtility();


  /// Get authentication token from storage
  Future<String> getToken() async {
    if (_token.isEmpty) {
      _token = await _storage.read('accessToken') ?? '';
    }
    return _token;
  }

  /// Clear cached token (useful for logout)
  static void clearToken() {
    _token = '';
  }

  /// Build headers with authentication and terminal ID
  Future<Map<String, String>> headers() async {
    await getToken();

    final baseHeaders = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $_token',

    };

    return baseHeaders;
  }

  /// Build URI with query parameters
  Uri buildUri(String path, {Map<String, dynamic>? queryParams}) {
    final uri = Uri.parse('$baseUrl$path');

    if (queryParams != null && queryParams.isNotEmpty) {
      // Convert all values to strings and filter out nulls
      final stringParams = queryParams.map(
              (key, value) => MapEntry(key, value?.toString() ?? '')
      )..removeWhere((key, value) => value.isEmpty);

      return uri.replace(queryParameters: stringParams);
    }

    return uri;
  }

  /// Handle GET requests
  Future<T> get<T>(
      String path, {
        Map<String, dynamic>? queryParams,
        required T Function(Map<String, dynamic>) fromJson,
      }) async {
    final uri = buildUri(path, queryParams: queryParams);
    final requestHeaders = await headers();

    try {
      final response = await http.get(uri, headers: requestHeaders);
      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      throw NetworkException(
        'error',
        'Network error. Please check your internet connection.',
      );
    } catch (e) {
      if (e is ExceptionUtility) rethrow;
      throw BadRequestException('error', e.toString());
    }
  }

  /// Handle POST requests
  Future<T> post<T>(
      String path, {
        Map<String, dynamic>? body,
        Map<String, dynamic>? queryParams,
        required T Function(Map<String, dynamic>) fromJson,
      }) async {
    final uri = buildUri(path, queryParams: queryParams);
    final requestHeaders = await headers();

    try {
      final response = await http.post(
        uri,
        headers: requestHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      throw NetworkException(
        'error',
        'Network error. Please check your internet connection.',
      );
    } catch (e) {
      if (e is ExceptionUtility) rethrow;
      throw BadRequestException('error', e.toString());
    }
  }

  /// Handle PUT requests
  Future<T> put<T>(
      String path, {
        Map<String, dynamic>? body,
        Map<String, dynamic>? queryParams,
        required T Function(Map<String, dynamic>) fromJson,
      }) async {
    final uri = buildUri(path, queryParams: queryParams);
    final requestHeaders = await headers();

    try {
      final response = await http.put(
        uri,
        headers: requestHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      throw NetworkException(
        'error',
        'Network error. Please check your internet connection.',
      );
    } catch (e) {
      if (e is ExceptionUtility) rethrow;
      throw BadRequestException('error', e.toString());
    }
  }

  /// Handle PATCH requests
  Future<T> patch<T>(
      String path, {
        Map<String, dynamic>? body,
        Map<String, dynamic>? queryParams,
        required T Function(Map<String, dynamic>) fromJson,
      }) async {
    final uri = buildUri(path, queryParams: queryParams);
    final requestHeaders = await headers();

    try {
      final response = await http.patch(
        uri,
        headers: requestHeaders,
        body: body != null ? jsonEncode(body) : null,
      );
      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      throw NetworkException(
        'error',
        'Network error. Please check your internet connection.',
      );
    } catch (e) {
      if (e is ExceptionUtility) rethrow;
      throw BadRequestException('error', e.toString());
    }
  }

  /// Handle DELETE requests
  Future<T> delete<T>(
      String path, {
        Map<String, dynamic>? queryParams,
        required T Function(Map<String, dynamic>) fromJson,
      }) async {
    final uri = buildUri(path, queryParams: queryParams);
    final requestHeaders = await headers();

    try {
      final response = await http.delete(uri, headers: requestHeaders);
      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      throw NetworkException(
        'error',
        'Network error. Please check your internet connection.',
      );
    } catch (e) {
      if (e is ExceptionUtility) rethrow;
      throw BadRequestException('error', e.toString());
    }
  }

  /// Handle HTTP responses uniformly
  T _handleResponse<T>(
      http.Response response,
      T Function(Map<String, dynamic>) fromJson,
      ) {
    final responseBody = response.body.isNotEmpty
        ? jsonDecode(response.body)
        : <String, dynamic>{};

    switch (response.statusCode) {
      case 200:
      case 201:
        return fromJson(responseBody);

      case 204: // No content
        return fromJson(<String, dynamic>{});

      case 400:
        final message = _parseErrorResponse(responseBody);
        throw BadRequestException('error', message);

      case 401:
        final message = _parseErrorResponse(responseBody);
        clearToken(); // Clear cached token
        throw UnauthorizedException('error', message);

      case 403:
        final message = _parseErrorResponse(responseBody);
        throw ForbiddenException('error', message);

      case 404:
        final message = _parseErrorResponse(responseBody);
        throw NotFoundException('error', message);

      case 409:
        final message = _parseErrorResponse(responseBody);
        throw DuplicateRequestException('error', message);

      case 422:
        final message = _parseErrorResponse(responseBody);
        throw ValidationException('error', message);

      case 429:
        throw RateLimitException(
          'error',
          'Too many requests. Please try again later.',
        );

      case 500:
      case 502:
      case 503:
      case 504:
        throw ServerException(
          'error',
          'Server error occurred. Please try again later.',
        );

      default:
        final message = _parseErrorResponse(responseBody);
        throw BadRequestException('error', message);
    }
  }

  /// Parse error response message
  String _parseErrorResponse(Map<String, dynamic> responseBody) {
    try {
      final res = Response.fromJson(responseBody);
      return res.message ?? 'An error occurred';
    } catch (e) {
      // If Response.fromJson fails, try to extract message directly
      return responseBody['message'] ??
          responseBody['error'] ??
          'An unexpected error occurred';
    }
  }

  /// Helper method for multipart requests (file uploads)
  Future<T> multipart<T>(
      String path, {
        required Map<String, String> fields,
        required List<http.MultipartFile> files,
        required T Function(Map<String, dynamic>) fromJson,
      }) async {
    final uri = buildUri(path);
    final requestHeaders = await headers();

    try {
      final request = http.MultipartRequest('POST', uri);

      // Add headers (remove Content-Type, it will be set automatically)
      requestHeaders.forEach((key, value) {
        if (key.toLowerCase() != 'content-type') {
          request.headers[key] = value;
        }
      });

      // Add fields
      request.fields.addAll(fields);

      // Add files
      request.files.addAll(files);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse<T>(response, fromJson);
    } on SocketException {
      throw NetworkException(
        'error',
        'Network error. Please check your internet connection.',
      );
    } catch (e) {
      if (e is ExceptionUtility) rethrow;
      throw BadRequestException('error', e.toString());
    }
  }
}