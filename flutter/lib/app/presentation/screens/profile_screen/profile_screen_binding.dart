import 'package:get/instance_manager.dart';
import 'profile_screen_controller.dart';

class ProfileScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ProfileScreenController());
  }
}