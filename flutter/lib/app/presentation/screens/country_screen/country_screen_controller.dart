import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/routes/named_routes.dart';

class CountryScreenController extends GetxController {

  final eitherOptionTapped = false.obs;
  final tappedButton = 0.obs;

  final temporaryTextEditingController = TextEditingController();
  final _countryCode = "".obs;
  bool get countryCodeNotEmpty => _countryCode.isNotEmpty;

  void onOptionButtonTap(int tappedButton) {
    eitherOptionTapped.value = true;
    this.tappedButton.value = tappedButton;
    if(tappedButton == 1) _countryCode.value = "82";
  }

  void onNextButtonTap() {
    print(_countryCode.value);
    Map<String, dynamic> argumentsData = {"country_code": int.parse(_countryCode.value)};
    Get.toNamed(Routes.Maker(nextRoute: Routes.EMAIL), arguments: argumentsData);
  }

  @override
  void onInit(){
    super.onInit();
    temporaryTextEditingController.addListener(() {_countryCode(temporaryTextEditingController.text);});

  }

  @override
  void onClose() {
    super.onClose();
    temporaryTextEditingController.dispose();
  }
}
