import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

/// Profile module dependency injection binding
class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
