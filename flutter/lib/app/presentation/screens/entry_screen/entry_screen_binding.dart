import 'package:get/instance_manager.dart';
import 'entry_screen_controller.dart';

class EntryScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(EntryScreenController());
  }
}