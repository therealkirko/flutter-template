import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../themes/app_theme.dart';

/// UI helper functions for displaying snackbars, dialogs, etc.
class UiHelpers {
  /// Show success snackbar
  static void showSuccess(String message, {String? title}) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title ?? '👏 Success',
      message,
      backgroundColor: AppColors.accent,
      colorText: AppColors.card,
      icon: Icon(Icons.celebration_outlined, color: AppColors.card),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      borderRadius: 12,
      shouldIconPulse: true,
    );
  }

  /// Show error snackbar
  static void showError(String message, {String? title}) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title ?? '⚡ Error',
      message,
      backgroundColor: AppColors.secondary,
      colorText: AppColors.card,
      icon: Icon(Icons.error_outline_outlined, color: AppColors.card),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 4),
      borderRadius: 12,
      shouldIconPulse: true,
    );
  }

  /// Show info snackbar
  static void showInfo(String message, {String? title}) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title ?? '⚠️ Info',
      message,
      backgroundColor: AppColors.primary,
      colorText: AppColors.card,
      icon: Icon(Icons.info_outline_rounded, color: AppColors.card),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      borderRadius: 12,
      shouldIconPulse: true,
    );
  }

  /// Show warning snackbar
  static void showWarning(String message, {String? title}) {
    Get.closeAllSnackbars();
    Get.snackbar(
      title ?? '⚠️ Warning',
      message,
      backgroundColor: Colors.orange,
      colorText: Colors.white,
      icon: const Icon(Icons.warning, color: Colors.white),
      snackPosition: SnackPosition.TOP,
      margin: const EdgeInsets.all(16),
      duration: const Duration(seconds: 3),
      borderRadius: 12,
      shouldIconPulse: true,
    );
  }

  /// Show loading dialog
  static void showLoading({String? message}) {
    Get.dialog(
      WillPopScope(
        onWillPop: () async => false,
        child: Center(
          child: Card(
            color: AppColors.card,
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.primary,
                    ),
                  ),
                  if (message != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      message,
                      style: TextStyle(color: AppColors.text),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Hide loading dialog
  static void hideLoading() {
    if (Get.isDialogOpen ?? false) {
      Get.back();
    }
  }

  /// Show confirmation dialog
  static Future<bool> showConfirmation({
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
  }) async {
    final result = await Get.dialog<bool>(
      AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Get.back(result: false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Get.back(result: true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.card,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );

    return result ?? false;
  }

  /// Show custom dialog
  static Future<T?> showCustomDialog<T>(Widget child) async {
    return await Get.dialog<T>(child);
  }

  /// Show bottom sheet
  static Future<T?> showBottomSheet<T>(Widget child) async {
    return await Get.bottomSheet<T>(
      child,
      backgroundColor: AppColors.card,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
    );
  }
}
