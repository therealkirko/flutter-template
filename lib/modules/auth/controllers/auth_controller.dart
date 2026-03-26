import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:template/core/routes/app_routes.dart';
import 'package:template/core/models/token_model.dart';
import 'package:template/core/utils/storage_utility.dart';
import 'package:template/core/mixins/state_handler_mixin.dart';
import 'package:template/modules/auth/services/auth_service.dart';

class AuthController extends GetxController with StateHandlerMixin {
  final isLoading = false.obs;
  final isAuthenticated = false.obs;
  final isPasswordVisible = false.obs;

  Rxn<User> user = Rxn<User>();
  Rxn<Token> token = Rxn<Token>();
  Rxn<Branch> branch = Rxn<Branch>();

  final StorageUtility storage = StorageUtility();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final registerFormKey = GlobalKey<FormState>();

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  Future<bool> verifyToken() async {
    try {
      final response = await AuthService().verify();

      user.value = response.data.user;
      branch.value = response.data.branch;

      isAuthenticated(true);

      return true;
    } catch (error) {
      isAuthenticated(false);
      storage.delete('accessToken');

      return false;
    }
  }

  void authenticate() async {
    isLoading(true);

    await AuthService().authenticate(emailController.text, passwordController.text).then((value) {

      storage.write('accessToken', value.data.token?.accessToken);

      user.value = value.data.user;
      branch.value = value.data.branch;

      handleState('success', value.message.toString());

      Get.toNamed(AppRoutes.home);

    }).catchError((error) {
      handleState('error', error.toString());
    }).whenComplete(() => isLoading(false));
  }
}
