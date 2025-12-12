import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../services/auth_service.dart';

/// Auth module dependency injection binding
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    // Inject AuthService
    Get.lazyPut<AuthService>(() => AuthService());

    // Inject AuthController
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
