import 'user_model.dart';
import 'token_model.dart';

/// Authentication response model
class AuthResponse {
  final bool? success;
  final String? message;
  final AuthData? data;

  AuthResponse({
    this.success,
    this.message,
    this.data,
  });

  /// Create from JSON
  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? AuthData.fromJson(json['data']) : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'data': data?.toJson(),
    };
  }
}

/// Authentication data
class AuthData {
  final User? user;
  final TokenData? token;

  AuthData({
    this.user,
    this.token,
  });

  /// Create from JSON
  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      user: json['user'] != null ? User.fromJson(json['user']) : null,
      token: json['token'] != null ? TokenData.fromJson(json['token']) : null,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'user': user?.toJson(),
      'token': token?.toJson(),
    };
  }
}
