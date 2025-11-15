import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

/// Auth module dependency injection binding
class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthController>(() => AuthController());
  }
}
