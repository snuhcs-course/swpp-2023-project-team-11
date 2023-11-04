import 'package:get/instance_manager.dart';
import 'room_screen_controller.dart';

class RoomScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(RoomScreenController());
  }
}