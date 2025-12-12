import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../services/user_service.dart';

/// Profile module dependency injection binding
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    // Inject UserService
    Get.lazyPut<UserService>(() => UserService());

    // Inject ProfileController
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
