import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/utils/validators.dart';
import '../../../core/utils/state_handler_mixin.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/services/token_service.dart';
import '../../../core/models/token_model.dart';
import '../../../core/models/user_model.dart';
/// Authentication controller
/// Handles login, register, PIN authentication, and authentication state
class AuthController extends GetxController with StateHandlerMixin {
  final TokenService _tokenService = Get.find<TokenService>();

  // Form controllers
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final pinController = TextEditingController();

  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  // Observable state
  final isLoading = false.obs;
  final isPasswordVisible = false.obs;
  final isAuthenticated = false.obs;
  final currentUser = Rxn<User>();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    pinController.dispose();
    super.onClose();
  }

  /// Toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  /// Check if user is authenticated
  bool get hasValidToken => _tokenService.hasToken() && !_tokenService.isTokenExpired();

  /// Login with email and password
  Future<void> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call - Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual login API call
      // Example:
      // final response = await authService.login(
      //   email: emailController.text,
      //   password: passwordController.text,
      // );

      // Mock token data - Replace with actual API response
      final mockToken = TokenData(
        accessToken: 'mock_access_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_refresh_token',
        tokenType: 'Bearer',
        expiresIn: 3600, // 1 hour
      );

      // Save token
      await _tokenService.saveToken(mockToken);

      isAuthenticated.value = true;

      // Show success message
      showSuccess('Login successful!');

      // Navigate to home
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      // Handle specific exceptions
      handleState('error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Authenticate with PIN (for terminal/POS style auth)
  Future<void> authenticateWithPin() async {
    if (pinController.text.isEmpty || pinController.text.length < 4) {
      showError('Please enter a valid PIN');
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call - Replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Implement actual PIN authentication API call
      // Example:
      // final response = await authService.authenticateWithPin(
      //   pin: pinController.text,
      //   terminalId: terminalId,
      //   userId: userId,
      // );

      // Mock token data - Replace with actual API response
      final mockToken = TokenData(
        accessToken: 'mock_pin_token_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'mock_refresh_token',
        tokenType: 'Bearer',
        expiresIn: 3600,
      );

      // Save token
      await _tokenService.saveToken(mockToken);

      isAuthenticated.value = true;

      // Clear PIN for security
      pinController.clear();

      // Show success message
      showSuccess('Authentication successful!');

      // Navigate to home
      Get.offAllNamed(AppRoutes.home);
    } catch (e) {
      // Handle specific exceptions
      handleState('error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Register new user
  Future<void> register() async {
    if (!registerFormKey.currentState!.validate()) {
      return;
    }

    try {
      isLoading.value = true;

      // Simulate API call - Replace with actual API call
      await Future.delayed(const Duration(seconds: 2));

      // TODO: Implement actual register API call
      // Example:
      // final response = await authService.register(
      //   name: nameController.text,
      //   email: emailController.text,
      //   password: passwordController.text,
      // );

      showSuccess('Registration successful!');

      // Navigate to login
      Get.offAllNamed(AppRoutes.login);
    } catch (e) {
      handleState('error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout user
  Future<void> logout() async {
    final confirmed = await showConfirmation(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
    );

    if (!confirmed) return;

    try {
      isLoading.value = true;

      // Clear token
      await _tokenService.clearToken();

      // Clear user state
      isAuthenticated.value = false;
      currentUser.value = null;

      // Navigate to login
      Get.offAllNamed(AppRoutes.login);

      showInfo('Logged out successfully');
    } catch (e) {
      handleState('error', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  /// Show confirmation dialog (from StateHandlerMixin)
  Future<bool> showConfirmation({
    required String title,
    required String message,
  }) async {
    return await UiHelpers.showConfirmation(
      title: title,
      message: message,
    );
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

  /// Validate PIN
  String? validatePin(String? value) {
    if (value == null || value.isEmpty) {
      return 'PIN is required';
    }
    if (value.length < 4) {
      return 'PIN must be at least 4 digits';
    }
    return null;
  }
}
