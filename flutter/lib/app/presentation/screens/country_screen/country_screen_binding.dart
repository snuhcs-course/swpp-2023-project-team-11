import 'package:get/instance_manager.dart';
import 'country_screen_controller.dart';

class CountryScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(CountryScreenController());
  }
}