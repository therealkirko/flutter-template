import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/connectivity_service.dart';
import '../themes/app_theme.dart';
import 'custom_button.dart';

/// Widget displayed when there's no internet connection
class NoInternetWidget extends StatelessWidget {
  final Widget child;

  const NoInternetWidget({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();

    return Obx(() {
      // If connected, show the child widget
      if (connectivityService.isConnected.value) {
        return child;
      }

      // If not connected, show no internet page
      return const NoInternetPage();
    });
  }
}

/// Full page displayed when there's no internet connection
class NoInternetPage extends StatelessWidget {
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.wifi_off_rounded,
                    size: 80,
                    color: AppColors.secondary,
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  'No Internet Connection',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.text,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                Text(
                  'Please check your internet connection and try again.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.subduedText,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 48),
                CustomButton(
                  text: 'Retry',
                  onPressed: () async {
                    final connectivityService = Get.find<ConnectivityService>();
                    await connectivityService.checkConnectivity();
                  },
                  icon: Icons.refresh,
                  width: 200,
                ),
                const SizedBox(height: 16),
                Obx(() {
                  final connectivityService = Get.find<ConnectivityService>();
                  return Text(
                    'Connection type: ${connectivityService.connectionTypeName}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.subduedText,
                    ),
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Wrapper widget that shows a snackbar when connection status changes
class ConnectivityWrapper extends StatelessWidget {
  final Widget child;
  final bool showSnackbar;

  const ConnectivityWrapper({
    Key? key,
    required this.child,
    this.showSnackbar = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final connectivityService = Get.find<ConnectivityService>();

    // Listen to connectivity changes and show snackbar
    if (showSnackbar) {
      ever(connectivityService.isConnected, (bool isConnected) {
        if (isConnected) {
          Get.closeAllSnackbars();
          Get.snackbar(
            'Connected',
            'Internet connection restored',
            backgroundColor: AppColors.accent,
            colorText: Colors.white,
            icon: const Icon(Icons.wifi, color: Colors.white),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 2),
          );
        } else {
          Get.closeAllSnackbars();
          Get.snackbar(
            'No Connection',
            'Please check your internet connection',
            backgroundColor: AppColors.secondary,
            colorText: Colors.white,
            icon: const Icon(Icons.wifi_off, color: Colors.white),
            snackPosition: SnackPosition.TOP,
            duration: const Duration(days: 1), // Keep showing until connected
            isDismissible: false,
          );
        }
      });
    }

    return child;
  }
}
