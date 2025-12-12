import 'dart:io';
import 'package:get/get.dart';
import 'api_service.dart';
import '../models/error_response_model.dart';
import '../utils/app_exception.dart';

/// Base service class that all module services should extend
/// Provides common HTTP methods: GET, POST, PUT, PATCH, DELETE
/// Supports file uploads with multipart/form-data
abstract class BaseService extends GetxService {
  late final ApiService _apiService;

  @override
  void onInit() {
    super.onInit();
    _apiService = Get.find<ApiService>();
  }

  /// GET request
  ///
  /// Example:
  /// ```dart
  /// final response = await get('/users', query: {'page': 1});
  /// ```
  Future<Response<T>> get<T>(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    return await _apiService.getRequest<T>(endpoint, query: query);
  }

  /// POST request
  ///
  /// Example:
  /// ```dart
  /// final response = await post('/users', body: {'name': 'John'});
  /// ```
  Future<Response<T>> post<T>(
    String endpoint, {
    dynamic body,
  }) async {
    return await _apiService.postRequest<T>(endpoint, body: body);
  }

  /// PUT request
  ///
  /// Example:
  /// ```dart
  /// final response = await put('/users/1', body: {'name': 'Jane'});
  /// ```
  Future<Response<T>> put<T>(
    String endpoint, {
    dynamic body,
  }) async {
    return await _apiService.putRequest<T>(endpoint, body: body);
  }

  /// PATCH request
  ///
  /// Example:
  /// ```dart
  /// final response = await patch('/users/1', body: {'name': 'Jane'});
  /// ```
  Future<Response<T>> patch<T>(
    String endpoint, {
    dynamic body,
  }) async {
    return await _apiService.patchRequest<T>(endpoint, body: body);
  }

  /// DELETE request
  ///
  /// Example:
  /// ```dart
  /// final response = await delete('/users/1');
  /// ```
  Future<Response<T>> delete<T>(
    String endpoint, {
    Map<String, dynamic>? query,
  }) async {
    return await _apiService.deleteRequest<T>(endpoint, query: query);
  }

  /// POST request with file upload
  /// Automatically converts to multipart/form-data
  ///
  /// Example:
  /// ```dart
  /// final response = await postWithFile(
  ///   '/users/avatar',
  ///   files: {'avatar': File('path/to/image.jpg')},
  ///   data: {'name': 'John'},
  /// );
  /// ```
  Future<Response<T>> postWithFile<T>(
    String endpoint, {
    required Map<String, File> files,
    Map<String, dynamic>? data,
  }) async {
    final formData = FormData({});

    // Add regular data fields
    if (data != null) {
      data.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });
    }

    // Add files
    for (var entry in files.entries) {
      final file = entry.value;
      final fileName = file.path.split('/').last;

      formData.files.add(
        MapEntry(
          entry.key,
          MultipartFile(file, filename: fileName),
        ),
      );
    }

    return await _apiService.postRequest<T>(endpoint, body: formData);
  }

  /// PUT request with file upload
  /// Automatically converts to multipart/form-data
  ///
  /// Example:
  /// ```dart
  /// final response = await putWithFile(
  ///   '/users/1/avatar',
  ///   files: {'avatar': File('path/to/image.jpg')},
  ///   data: {'name': 'John'},
  /// );
  /// ```
  Future<Response<T>> putWithFile<T>(
    String endpoint, {
    required Map<String, File> files,
    Map<String, dynamic>? data,
  }) async {
    final formData = FormData({});

    // Add regular data fields
    if (data != null) {
      data.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });
    }

    // Add files
    for (var entry in files.entries) {
      final file = entry.value;
      final fileName = file.path.split('/').last;

      formData.files.add(
        MapEntry(
          entry.key,
          MultipartFile(file, filename: fileName),
        ),
      );
    }

    return await _apiService.putRequest<T>(endpoint, body: formData);
  }

  /// POST request with multiple files
  /// Supports array of files for a single field
  ///
  /// Example:
  /// ```dart
  /// final response = await postWithFiles(
  ///   '/gallery/upload',
  ///   files: {
  ///     'images': [File('image1.jpg'), File('image2.jpg')],
  ///     'thumbnail': [File('thumb.jpg')],
  ///   },
  ///   data: {'gallery_name': 'My Gallery'},
  /// );
  /// ```
  Future<Response<T>> postWithFiles<T>(
    String endpoint, {
    required Map<String, List<File>> files,
    Map<String, dynamic>? data,
  }) async {
    final formData = FormData({});

    // Add regular data fields
    if (data != null) {
      data.forEach((key, value) {
        formData.fields.add(MapEntry(key, value.toString()));
      });
    }

    // Add files
    for (var entry in files.entries) {
      for (var file in entry.value) {
        final fileName = file.path.split('/').last;

        formData.files.add(
          MapEntry(
            '${entry.key}[]', // Array notation for multiple files
            MultipartFile(file, filename: fileName),
          ),
        );
      }
    }

    return await _apiService.postRequest<T>(endpoint, body: formData);
  }

  /// Helper method to handle response and extract data
  /// Throws appropriate exceptions if response is not successful
  ///
  /// Example:
  /// ```dart
  /// final response = await get('/users');
  /// final data = handleResponse(response);
  /// ```
  T handleResponse<T>(Response<T> response) {
    if (response.hasError) {
      throw AppException('error', response.statusText ?? 'Request failed');
    }

    if (response.body == null) {
      throw AppException('error', 'Empty response body');
    }

    return response.body!;
  }

  /// Helper method to extract data from standard API response
  /// Assumes response format: { "success": bool, "message": string, "data": T }
  ///
  /// Example:
  /// ```dart
  /// final response = await get('/users');
  /// final users = extractData<List>(response, 'data');
  /// ```
  T? extractData<T>(Response response, String key) {
    if (response.body is Map) {
      final map = response.body as Map<String, dynamic>;
      return map[key] as T?;
    }
    return null;
  }
}
