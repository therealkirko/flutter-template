import 'package:get/get.dart';
import '../models/token_model.dart';
import 'storage_service.dart';

/// Token management service
/// Handles token storage, retrieval, refresh, and expiry
class TokenService extends GetxService {
  final StorageService _storage = Get.find<StorageService>();

  // Storage keys
  static const String _accessTokenKey = 'access_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _tokenTypeKey = 'token_type';
  static const String _expiresInKey = 'expires_in';
  static const String _tokenSavedAtKey = 'token_saved_at';

  /// Save token data
  Future<void> saveToken(TokenData token) async {
    await _storage.write(_accessTokenKey, token.accessToken);
    await _storage.write(_refreshTokenKey, token.refreshToken);
    await _storage.write(_tokenTypeKey, token.tokenType ?? 'Bearer');
    await _storage.write(_expiresInKey, token.expiresIn);
    await _storage.write(
      _tokenSavedAtKey,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Get access token
  String? getAccessToken() {
    return _storage.read<String>(_accessTokenKey);
  }

  /// Get refresh token
  String? getRefreshToken() {
    return _storage.read<String>(_refreshTokenKey);
  }

  /// Get token type
  String getTokenType() {
    return _storage.read<String>(_tokenTypeKey) ?? 'Bearer';
  }

  /// Get full authorization header value
  String? getAuthHeader() {
    final token = getAccessToken();
    if (token == null) return null;
    return '${getTokenType()} $token';
  }

  /// Check if token exists
  bool hasToken() {
    return getAccessToken() != null;
  }

  /// Check if token is expired
  bool isTokenExpired() {
    final expiresIn = _storage.read<int>(_expiresInKey);
    final savedAt = _storage.read<int>(_tokenSavedAtKey);

    if (expiresIn == null || savedAt == null) {
      return true;
    }

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(savedAt)
        .add(Duration(seconds: expiresIn));

    return DateTime.now().isAfter(expiresAt);
  }

  /// Check if token is about to expire (within 5 minutes)
  bool isTokenExpiringS oon() {
    final expiresIn = _storage.read<int>(_expiresInKey);
    final savedAt = _storage.read<int>(_tokenSavedAtKey);

    if (expiresIn == null || savedAt == null) {
      return true;
    }

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(savedAt)
        .add(Duration(seconds: expiresIn));
    final fiveMinutesFromNow = DateTime.now().add(const Duration(minutes: 5));

    return fiveMinutesFromNow.isAfter(expiresAt);
  }

  /// Get token data
  TokenData? getTokenData() {
    final accessToken = getAccessToken();
    if (accessToken == null) return null;

    return TokenData(
      accessToken: accessToken,
      refreshToken: getRefreshToken(),
      tokenType: getTokenType(),
      expiresIn: _storage.read<int>(_expiresInKey),
    );
  }

  /// Clear all token data
  Future<void> clearToken() async {
    await _storage.remove(_accessTokenKey);
    await _storage.remove(_refreshTokenKey);
    await _storage.remove(_tokenTypeKey);
    await _storage.remove(_expiresInKey);
    await _storage.remove(_tokenSavedAtKey);
  }

  /// Get time until token expires
  Duration? getTimeUntilExpiry() {
    final expiresIn = _storage.read<int>(_expiresInKey);
    final savedAt = _storage.read<int>(_tokenSavedAtKey);

    if (expiresIn == null || savedAt == null) {
      return null;
    }

    final expiresAt = DateTime.fromMillisecondsSinceEpoch(savedAt)
        .add(Duration(seconds: expiresIn));

    return expiresAt.difference(DateTime.now());
  }
}
