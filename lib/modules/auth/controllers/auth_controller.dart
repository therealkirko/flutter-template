import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../core/utils/validators.dart';
import '../../../core/routes/app_routes.dart';

/// Authentication controller
/// Handles login, register, and authentication state
class AuthController extends GetxController {
  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Observable state
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isAuthenticated = false.obs;

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.onClose();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Login user
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual login API call
      // Example:
      // final response = await authService.login(
      //   email: emailController.text,
      //   password: passwordController.text,
      // );

      isAuthenticated.value = true;

      UiHelpers.showSuccess('Login successful!');

      // Navigate to home
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      UiHelpers.showError('Login failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Register user
  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual register API call
      // Example:
      // final response = await authService.register(
      //   name: nameController.text,
      //   email: emailController.text,
      //   password: passwordController.text,
      // );

      UiHelpers.showSuccess('Registration successful!');

      // Navigate to login
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      UiHelpers.showError('Registration failed: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    final confirmed = await UiHelpers.showConfirmation(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
    );

    if (confirmed) {
      isAuthenticated.value = false;
      Get.offAllNamed(AppRoutes.login);
      UiHelpers.showInfo('Logged out successfully');
    }
  }

  /// Validate email
  String? validateEmail(String? value) => Validators.validateEmail(value);

  /// Validate password
  String? validatePassword(String? value) => Validators.validatePassword(value);

  /// Validate confirm password
  String? validateConfirmPassword(String? value) =>
      Validators.validateConfirmPassword(value, passwordController.text);

  /// Validate name
  String? validateName(String? value) =>
      Validators.validateRequired(value, fieldName: 'Name');
}
