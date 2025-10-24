/// Token model for authentication
class Token {
  final bool? success;
  final String? message;
  final TokenData? data;

  Token({
    this.success,
    this.message,
    this.data,
  });

  /// Create from JSON
  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      success: json['success'] as bool?,
      message: json['message'] as String?,
      data: json['data'] != null ? TokenData.fromJson(json['data']) : null,
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

/// Token data
class TokenData {
  final String? accessToken;
  final String? refreshToken;
  final String? tokenType;
  final int? expiresIn;

  TokenData({
    this.accessToken,
    this.refreshToken,
    this.tokenType,
    this.expiresIn,
  });

  /// Create from JSON
  factory TokenData.fromJson(Map<String, dynamic> json) {
    return TokenData(
      accessToken: json['access_token'] as String?,
      refreshToken: json['refresh_token'] as String?,
      tokenType: json['token_type'] as String?,
      expiresIn: json['expires_in'] as int?,
    );
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'access_token': accessToken,
      'refresh_token': refreshToken,
      'token_type': tokenType,
      'expires_in': expiresIn,
    };
  }
}
