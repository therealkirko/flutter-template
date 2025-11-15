import 'package:get/get.dart';
import '../../../core/utils/ui_helpers.dart';
import '../../../core/routes/app_routes.dart';
import '../models/user_model.dart';

/// Profile controller
/// Manages user profile state and actions
class ProfileController extends GetxController {
  // Observable state
  final isLoading = false.obs;
  final user = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    loadUserProfile();
  }

  /// Load user profile
  Future<void> loadUserProfile() async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Implement actual profile fetching
      user.value = UserModel(
        id: '1',
        name: 'John Doe',
        email: 'john.doe@example.com',
        avatar: null,
        phone: '+1234567890',
        bio: 'Flutter developer passionate about clean architecture.',
      );
    } catch (e) {
      UiHelpers.showError('Failed to load profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Update profile
  Future<void> updateProfile(UserModel updatedUser) async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // TODO: Implement actual profile update
      user.value = updatedUser;

      UiHelpers.showSuccess('Profile updated successfully');
    } catch (e) {
      UiHelpers.showError('Failed to update profile: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  /// Logout
  Future<void> logout() async {
    final confirmed = await UiHelpers.showConfirmation(
      title: 'Logout',
      message: 'Are you sure you want to logout?',
    );

    if (confirmed) {
      // Clear user data
      user.value = null;

      // Navigate to login
      Get.offAllNamed(AppRoutes.login);

      UiHelpers.showInfo('Logged out successfully');
    }
  }

  /// Navigate to edit profile
  void navigateToEditProfile() {
    // TODO: Navigate to edit profile screen
    UiHelpers.showInfo('Edit profile coming soon');
  }

  /// Navigate to settings
  void navigateToSettings() {
    // TODO: Navigate to settings screen
    UiHelpers.showInfo('Settings coming soon');
  }
}
