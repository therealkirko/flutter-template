import 'package:get/get.dart';
import '../controllers/home_controller.dart';

/// Home module dependency injection binding
class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(() => HomeController());
  }
}
