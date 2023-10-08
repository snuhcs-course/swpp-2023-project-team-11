import 'package:get/instance_manager.dart';
import 'sign_up_screen_controller.dart';

class SignUpScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(SignUpScreenController());
  }
}