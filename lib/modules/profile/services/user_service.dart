import 'dart:io';
import 'package:get/get.dart';
import '../../../core/services/base_service.dart';
import '../../../core/models/user_model.dart';
import '../models/user_model.dart' as profile_user;

/// User service
/// Handles all user-related API calls (CRUD operations)
class UserService extends BaseService {
  /// Get current authenticated user profile
  ///
  /// Returns: User data
  Future<User> getProfile() async {
    final response = await get('/user/profile');

    return User.fromJson(response.body);
  }

  /// Get user by ID
  ///
  /// Returns: User data
  Future<User> getUserById(String userId) async {
    final response = await get('/users/$userId');

    return User.fromJson(response.body);
  }

  /// Get list of users with pagination
  ///
  /// Returns: List of users
  Future<List<User>> getUsers({
    int page = 1,
    int perPage = 20,
    String? search,
  }) async {
    final response = await get(
      '/users',
      query: {
        'page': page,
        'per_page': perPage,
        if (search != null) 'search': search,
      },
    );

    final data = extractData<List>(response, 'data');
    return data?.map((json) => User.fromJson(json)).toList() ?? [];
  }

  /// Update current user profile
  ///
  /// Returns: Updated user data
  Future<User> updateProfile({
    String? name,
    String? email,
    String? phone,
    String? bio,
  }) async {
    final response = await put(
      '/user/profile',
      body: {
        if (name != null) 'name': name,
        if (email != null) 'email': email,
        if (phone != null) 'phone': phone,
        if (bio != null) 'bio': bio,
      },
    );

    return User.fromJson(response.body);
  }

  /// Upload user avatar
  ///
  /// Returns: Updated user with new avatar URL
  Future<User> uploadAvatar({
    required File avatar,
  }) async {
    final response = await postWithFile(
      '/user/avatar',
      files: {
        'avatar': avatar,
      },
    );

    return User.fromJson(response.body);
  }

  /// Update user profile with avatar
  /// Combines profile update and avatar upload
  ///
  /// Returns: Updated user data
  Future<User> updateProfileWithAvatar({
    required File avatar,
    String? name,
    String? phone,
    String? bio,
  }) async {
    final response = await putWithFile(
      '/user/profile',
      files: {
        'avatar': avatar,
      },
      data: {
        if (name != null) 'name': name,
        if (phone != null) 'phone': phone,
        if (bio != null) 'bio': bio,
      },
    );

    return User.fromJson(response.body);
  }

  /// Delete user account
  ///
  /// Returns: Success response
  Future<void> deleteAccount() async {
    await delete('/user/profile');
  }

  /// Change user password
  ///
  /// Returns: Success response with message
  Future<Map<String, dynamic>> changePassword({
    required String currentPassword,
    required String newPassword,
    required String newPasswordConfirmation,
  }) async {
    final response = await put(
      '/user/password',
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
        'new_password_confirmation': newPasswordConfirmation,
      },
    );

    return response.body as Map<String, dynamic>;
  }

  /// Upload multiple user documents
  /// Example: ID card, proof of address, etc.
  ///
  /// Returns: Success response with uploaded document URLs
  Future<Map<String, dynamic>> uploadDocuments({
    required List<File> documents,
    required String documentType,
  }) async {
    final response = await postWithFiles(
      '/user/documents',
      files: {
        'documents': documents,
      },
      data: {
        'type': documentType,
      },
    );

    return response.body as Map<String, dynamic>;
  }

  /// Get user preferences/settings
  ///
  /// Returns: User preferences map
  Future<Map<String, dynamic>> getPreferences() async {
    final response = await get('/user/preferences');

    return response.body as Map<String, dynamic>;
  }

  /// Update user preferences/settings
  ///
  /// Returns: Updated preferences
  Future<Map<String, dynamic>> updatePreferences({
    required Map<String, dynamic> preferences,
  }) async {
    final response = await put(
      '/user/preferences',
      body: preferences,
    );

    return response.body as Map<String, dynamic>;
  }
}
