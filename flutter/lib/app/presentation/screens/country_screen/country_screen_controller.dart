import 'package:get/get.dart';
import 'package:mobile_app/routes/named_routes.dart';

class CountryScreenController extends GetxController {
  final eitherOptionTapped = false.obs;
  final tappedButton = 0.obs;

  void onOptionButtonTap(int tappedButton) {
    eitherOptionTapped.value = true;
    this.tappedButton.value = tappedButton;
  }

  void onNextButtonTap() {
    Get.toNamed(Routes.Maker(nextRoute: Routes.EMAIL));
  }
}
