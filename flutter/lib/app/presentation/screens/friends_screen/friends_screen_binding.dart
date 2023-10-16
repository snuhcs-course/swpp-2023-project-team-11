import 'package:get/instance_manager.dart';
import 'friends_screen_controller.dart';

class FriendsScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(FriendsScreenController());
  }
}