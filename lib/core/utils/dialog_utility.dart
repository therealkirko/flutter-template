import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:template/core/themes/app_theme.dart';

class DialogUtility
{
  static void showDialog({required String state, required String message}) {
    Get.snackbar(
        (state == 'error') ? '⚡ Error' : (state == 'info') ? '⚠️ Info' : '👏 Success',
        message,
        shouldIconPulse: true,
        colorText: AppColors.card,
        backgroundColor: (state == 'error') ? Colors.redAccent : (state == 'info') ? AppColors.primary : AppColors.accent,
        icon: Icon(
          (state == 'error') ? Icons.error_outline_outlined : (state == 'info') ? Icons.info_outline_rounded : Icons.celebration_outlined,
          color: AppColors.card,
        ),
        snackPosition: SnackPosition.TOP
    );
  }
}
