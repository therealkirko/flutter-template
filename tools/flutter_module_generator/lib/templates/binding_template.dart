class BindingTemplate {
  static String generate(String moduleName, String className, String controllerClass, String serviceClass) {
    return '''import 'package:get/get.dart';
import '../controllers/$moduleName\_controller.dart';
import '../services/$moduleName\_service.dart';

/// $className binding
/// Dependency injection for $moduleName module
class $className extends Bindings {
  @override
  void dependencies() {
    // Inject service
    Get.lazyPut<$serviceClass>(() => $serviceClass());

    // Inject controller
    Get.lazyPut<$controllerClass>(() => $controllerClass());
  }
}
''';
  }
}
