import 'package:get/get.dart';
import 'package:macos_dock/features/dock/controller/dock_controller.dart';

class DockBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DockController>(() => DockController());
  }
}
