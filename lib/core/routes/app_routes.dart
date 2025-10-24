/// Application route names
/// Add your module routes here
class AppRoutes {
  // Core routes
  static const String initial = '/';
  static const String splash = '/splash';

  // Auth module routes
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String forgotPassword = '/auth/forgot-password';

  // Home module routes
  static const String home = '/home';
  static const String dashboard = '/home/dashboard';

  // Profile module routes
  static const String profile = '/profile';
  static const String editProfile = '/profile/edit';
  static const String settings = '/profile/settings';

  // Add more routes as needed
}
