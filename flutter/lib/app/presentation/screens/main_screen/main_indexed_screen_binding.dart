import 'package:get/instance_manager.dart';
import 'package:mobile_app/app/presentation/screens/friends_screen/friends_screen_controller.dart';
import 'main_indexed_screen_controller.dart';

class MainIndexedScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(MainIndexedScreenController());
  }
}