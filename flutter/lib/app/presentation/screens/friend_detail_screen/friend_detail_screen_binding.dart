import 'package:get/instance_manager.dart';
import 'friend_detail_screen_controller.dart';

class FriendDetailScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(FriendDetailScreenController());
  }
}