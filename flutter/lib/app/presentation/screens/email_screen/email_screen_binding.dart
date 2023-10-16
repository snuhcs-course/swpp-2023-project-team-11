import 'package:get/instance_manager.dart';
import 'email_screen_controller.dart';

class EmailScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(EmailScreenController());
  }
}