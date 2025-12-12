import 'package:get/get.dart';
import '../../../core/services/base_service.dart';
import '../../../core/models/token_model.dart';
import '../../../core/models/auth_response_model.dart';
import '../../../core/config/app_constants.dart';

/// Authentication service
/// Handles all authentication-related API calls
class AuthService extends BaseService {
  /// Login with email and password
  ///
  /// Returns: Token with access and refresh tokens
  Future<Token> login({
    required String email,
    required String password,
  }) async {
    final response = await post(
      AppConstants.endpointLogin,
      body: {
        'email': email,
        'password': password,
      },
    );

    return Token.fromJson(response.body);
  }

  /// Register new user
  ///
  /// Returns: AuthResponse with user and token data
  Future<AuthResponse> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await post(
      AppConstants.endpointRegister,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    return AuthResponse.fromJson(response.body);
  }

  /// Authenticate with PIN (for terminal/POS applications)
  ///
  /// Returns: Token with access and refresh tokens
  Future<Token> authenticateWithPin({
    required String pin,
    required dynamic terminalId,
    required dynamic userId,
  }) async {
    final response = await post(
      '/oauth/token',
      body: {
        'pin': pin,
        'terminal': terminalId.toString(),
        'user': userId.toString(),
      },
    );

    return Token.fromJson(response.body);
  }

  /// Refresh access token using refresh token
  ///
  /// Returns: New token with updated access token
  Future<Token> refreshToken({
    required String refreshToken,
  }) async {
    final response = await post(
      '/oauth/refresh',
      body: {
        'refresh_token': refreshToken,
      },
    );

    return Token.fromJson(response.body);
  }

  /// Logout current user
  ///
  /// Returns: Success response
  Future<void> logout() async {
    await post('/auth/logout');
  }

  /// Request password reset
  ///
  /// Returns: Success response with message
  Future<Map<String, dynamic>> forgotPassword({
    required String email,
  }) async {
    final response = await post(
      '/auth/forgot-password',
      body: {
        'email': email,
      },
    );

    return response.body as Map<String, dynamic>;
  }

  /// Reset password with token
  ///
  /// Returns: Success response with message
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String token,
    required String password,
    required String passwordConfirmation,
  }) async {
    final response = await post(
      '/auth/reset-password',
      body: {
        'email': email,
        'token': token,
        'password': password,
        'password_confirmation': passwordConfirmation,
      },
    );

    return response.body as Map<String, dynamic>;
  }

  /// Verify email with token
  ///
  /// Returns: Success response
  Future<Map<String, dynamic>> verifyEmail({
    required String token,
  }) async {
    final response = await post(
      '/auth/verify-email',
      body: {
        'token': token,
      },
    );

    return response.body as Map<String, dynamic>;
  }

  /// Resend email verification
  ///
  /// Returns: Success response with message
  Future<Map<String, dynamic>> resendVerificationEmail() async {
    final response = await post('/auth/resend-verification');

    return response.body as Map<String, dynamic>;
  }
}
