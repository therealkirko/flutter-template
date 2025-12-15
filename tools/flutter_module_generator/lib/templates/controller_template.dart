class ControllerTemplate {
  static String generate(String moduleName, String className) {
    return '''import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/state_handler_mixin.dart';
import '../services/${moduleName}_service.dart';

/// $className controller
/// Handles business logic for $moduleName module
class $className extends GetxController with StateHandlerMixin {
  final ${className.replaceAll('Controller', 'Service')} _service = Get.find<${className.replaceAll('Controller', 'Service')}>();

  // Observable state
  final isLoading = false.obs;
  final data = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  /// Load data
  Future<void> loadData() async {
    try {
      isLoading.value = true;

      // TODO: Implement data loading logic
      // Example:
      // data.value = await _service.getData();

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      showSuccess('Data loaded successfully!');
    } catch (e) {
      handleState('error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Refresh data
  Future<void> refresh() async {
    await loadData();
  }

  @override
  void onClose() {
    // Clean up resources
    super.onClose();
  }
}
''';
  }
}
