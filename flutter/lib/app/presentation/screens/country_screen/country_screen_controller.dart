import 'package:get/get.dart';

class CountryScreenController extends GetxController {
  final eitherOptionTapped = false.obs;
  final tappedButton = 0.obs;

  void onOptionButtonTap(int tappedButton) {
    eitherOptionTapped.value = true;
    this.tappedButton.value = tappedButton;
  }

  CountryScreenController();
}
