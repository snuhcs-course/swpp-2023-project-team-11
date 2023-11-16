import 'package:get/instance_manager.dart';
import 'chat_requests_screen_controller.dart';

class ChatRequestsScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ChatRequestsScreenController());
  }
}