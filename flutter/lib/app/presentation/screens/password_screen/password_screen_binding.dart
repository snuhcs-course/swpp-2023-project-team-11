import 'package:get/instance_manager.dart';
import 'password_screen_controller.dart';

class PasswordScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(PasswordScreenController());
  }
}