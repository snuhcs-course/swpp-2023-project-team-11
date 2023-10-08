import 'package:get/instance_manager.dart';
import 'first_screen_controller.dart';

class FirstScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(FirstScreenController());
  }
}