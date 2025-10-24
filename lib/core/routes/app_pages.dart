import 'package:get/get.dart';
import 'app_routes.dart';

// Import module pages
import '../../modules/auth/bindings/auth_binding.dart';
import '../../modules/auth/views/login_view.dart';
import '../../modules/auth/views/register_view.dart';

import '../../modules/home/bindings/home_binding.dart';
import '../../modules/home/views/home_view.dart';

import '../../modules/profile/bindings/profile_binding.dart';
import '../../modules/profile/views/profile_view.dart';

/// Central app pages configuration
/// This combines all module pages into one place
class AppPages {
  static const initial = AppRoutes.home;

  static final routes = [
    // Auth module routes
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: AppRoutes.register,
      page: () => const RegisterView(),
      binding: AuthBinding(),
    ),

    // Home module routes
    GetPage(
      name: AppRoutes.home,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),

    // Profile module routes
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),

    // Add more module routes here as you create new modules
  ];
}
