import 'package:get/get.dart';
import 'package:template/modules/profile/controllers/profile_controller.dart';

/// Profile module dependency injection binding
class ProfileBinding extends Bindings {
  @override
  void dependencies() {

    // Inject ProfileController
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
