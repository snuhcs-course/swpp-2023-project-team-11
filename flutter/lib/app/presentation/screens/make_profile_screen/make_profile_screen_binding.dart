import 'package:get/instance_manager.dart';
import 'make_profile_screen_controller.dart';

class MakeProfileScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(MakeProfileScreenController());
  }
}