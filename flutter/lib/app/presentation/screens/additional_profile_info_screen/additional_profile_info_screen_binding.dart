import 'package:get/instance_manager.dart';
import 'additional_profile_info_screen_controller.dart';

class AdditionalProfileInfoScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(AdditionalProfileInfoScreenController());
  }
}