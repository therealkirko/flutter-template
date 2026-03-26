import 'app_routes.dart';
import 'package:get/get.dart';
import 'package:template/modules/home/views/index.dart';
import 'package:template/modules/delivery/views/index.dart';
import 'package:template/modules/auth/views/login_view.dart';
import 'package:template/modules/requisitions/views/index.dart';
import 'package:template/modules/requisitions/views/details.dart';
import 'package:template/modules/delivery/views/receivables.dart';
import 'package:template/modules/profile/views/profile_view.dart';
import 'package:template/modules/profile/bindings/profile_binding.dart';
import 'package:template/modules/delivery/bindings/delivery_binding.dart';
import 'package:template/modules/delivery/controllers/receivable_controller.dart';
import 'package:template/modules/requisitions/views/create_requisition_step1.dart';
import 'package:template/modules/requisitions/views/create_requisition_step2.dart';

class AppPages {
  static const initial = AppRoutes.login;

  static final routes = [
    // Auth module routes
    GetPage(
      name: AppRoutes.login,
      page: () => LoginView(),
    ),

    // Home module routes
    GetPage(
      name: AppRoutes.home,
      page: () => HomeView(),
    ),

    // Profile module routes
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),

    GetPage(
      name: AppRoutes.requisition,
      page: () => const RequisitionDetailsPage(),
    ),

    GetPage(
      name: AppRoutes.requisitions,
      page: () => RequisitionsPage(),
    ),

    GetPage(
      name: AppRoutes.createRequisition,
      page: () => CreateRequisitionStep1(),
    ),

    GetPage(
      name: AppRoutes.createRequisition2,
      page: () => CreateRequisitionStep2(),
    ),

    // Delivery module routes
    GetPage(
      name: AppRoutes.delivery,
      page: () => DeliveryPage(),
      binding: DeliveryBinding(),
    ),
    GetPage(
      name: AppRoutes.receivables,
      page: () {
        final order = Get.arguments;
        Get.put(ReceivableController()..order = order..init());
        return ReceiveDeliveryPage(order: order);
      },
    ),
  ];
}
