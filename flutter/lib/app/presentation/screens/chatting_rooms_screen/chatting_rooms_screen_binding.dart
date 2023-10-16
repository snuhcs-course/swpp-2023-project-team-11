import 'package:get/instance_manager.dart';
import 'chatting_rooms_screen_controller.dart';

class ChattingRoomsScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ChattingRoomsScreenController());
  }
}