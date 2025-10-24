/// Application-wide constants
class AppConstants {
  // Storage Keys
  static const String storageKeyToken = 'auth_token';
  static const String storageKeyUser = 'user_data';
  static const String storageKeyTheme = 'theme_mode';
  static const String storageKeyLanguage = 'language';

  // API Endpoints
  static const String endpointLogin = '/auth/login';
  static const String endpointRegister = '/auth/register';
  static const String endpointProfile = '/user/profile';

  // Timeouts & Limits
  static const int splashDuration = 2; // seconds
  static const int maxRetries = 3;
  static const int pageSize = 20;

  // Validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 32;
}
