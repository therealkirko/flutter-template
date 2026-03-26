import 'package:get/get.dart';
import 'package:template/modules/delivery/controllers/delivery_controller.dart';

class DeliveryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DeliveryController>(() => DeliveryController());
  }
}