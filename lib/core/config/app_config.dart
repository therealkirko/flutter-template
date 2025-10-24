/// App-wide configuration constants
class AppConfig {
  // App Information
  static const String appName = 'Flutter Template';
  static const String appVersion = '1.0.0';

  // API Configuration
  static const String baseUrl = 'https://api.example.com';
  static const int apiTimeout = 30; // seconds

  // Feature Flags
  static const bool enableLogging = true;
  static const bool enableAnalytics = false;

  // Environment
  static const Environment environment = Environment.development;
}

enum Environment {
  development,
  staging,
  production,
}
