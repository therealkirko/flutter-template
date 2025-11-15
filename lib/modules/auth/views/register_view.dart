import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class RegisterView extends GetView<AuthController> {
  const RegisterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: controller.registerFormKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // App logo or icon
                  Icon(
                    Icons.person_add_outlined,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 24),

                  Text(
                    'Create Account',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  Text(
                    'Sign up to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Name field
                  CustomTextField(
                    label: 'Full Name',
                    hint: 'Enter your full name',
                    controller: controller.nameController,
                    validator: controller.validateName,
                    prefixIcon: const Icon(Icons.person_outlined),
                  ),
                  const SizedBox(height: 16),

                  // Email field
                  CustomTextField(
                    label: 'Email',
                    hint: 'Enter your email',
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    validator: controller.validateEmail,
                    prefixIcon: const Icon(Icons.email_outlined),
                  ),
                  const SizedBox(height: 16),

                  // Password field
                  Obx(
                    () => CustomTextField(
                      label: 'Password',
                      hint: 'Enter your password',
                      controller: controller.passwordController,
                      obscureText: !controller.isPasswordVisible.value,
                      validator: controller.validatePassword,
                      prefixIcon: const Icon(Icons.lock_outlined),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Confirm password field
                  Obx(
                    () => CustomTextField(
                      label: 'Confirm Password',
                      hint: 'Confirm your password',
                      controller: controller.confirmPasswordController,
                      obscureText: !controller.isPasswordVisible.value,
                      validator: controller.validateConfirmPassword,
                      prefixIcon: const Icon(Icons.lock_outlined),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Register button
                  Obx(
                    () => CustomButton(
                      text: 'Register',
                      onPressed: controller.register,
                      isLoading: controller.isLoading.value,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Login link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account? '),
                      TextButton(
                        onPressed: () => Get.back(),
                        child: const Text('Login'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
