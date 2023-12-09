import 'package:get/instance_manager.dart';
import 'main_indexed_screen_controller.dart';

class MainIndexedScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(MainIndexedScreenController());
  }
}