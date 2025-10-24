import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/routes/app_pages.dart';
import 'core/routes/app_routes.dart';
import 'core/themes/app_theme.dart';
import 'core/config/app_config.dart';
import 'core/services/connectivity_service.dart';
import 'core/widgets/no_internet_widget.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize connectivity service
  await Get.putAsync(() => ConnectivityService().init());

  // Initialize other services here if needed
  // Example: await Get.putAsync(() => StorageService().init());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,

      // Theme configuration
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // GetX routing
      initialRoute: AppPages.initial,
      getPages: AppPages.routes,
      defaultTransition: Transition.cupertino,

      // Builder to wrap all pages with connectivity check
      builder: (context, child) {
        return ConnectivityWrapper(
          child: NoInternetWidget(
            child: child ?? const SizedBox.shrink(),
          ),
        );
      },

      // Unknown route handler
      unknownRoute: GetPage(
        name: '/not-found',
        page: () => const Scaffold(
          body: Center(
            child: Text('Page not found'),
          ),
        ),
      ),

      // Localization (optional - configure if needed)
      // locale: Get.deviceLocale,
      // fallbackLocale: const Locale('en', 'US'),
    );
  }
}
