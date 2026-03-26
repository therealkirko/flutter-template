import 'package:get/get.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:template/core/routes/app_pages.dart';
import 'package:template/core/themes/app_theme.dart';
import 'package:template/core/routes/app_routes.dart';
import 'package:template/core/config/app_config.dart';
import 'package:template/core/utils/storage_utility.dart';
import 'package:template/modules/auth/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize auth controller
  final controller = Get.put(AuthController());

  // Check authentication status
  final storage = StorageUtility();
  final token = await storage.read('accessToken');

  bool authenticated = false;

  if (token != null) {
    authenticated = await controller.verifyToken();
  }

  runApp(MyApp(authenticated: authenticated));
}

class MyApp extends StatelessWidget {
  final bool authenticated;
  const MyApp({super.key, required this.authenticated});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: _buildTheme(Brightness.light),

      // Navigation
      initialRoute: authenticated ? AppRoutes.home : AppPages.initial,
      getPages: AppPages.routes,

    );
  }


  ThemeData _buildTheme(Brightness brightness) {
    var baseTheme = AppColors.theme;

    return baseTheme.copyWith(
      textTheme: GoogleFonts.latoTextTheme(baseTheme.textTheme),
      appBarTheme: baseTheme.appBarTheme.copyWith(
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          systemNavigationBarColor: Colors.transparent,
          systemNavigationBarIconBrightness: Brightness.dark,
        ),
      ),
    );
  }

}