import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/routes/named_routes.dart';

class PasswordScreenController extends GetxController {
  final TextEditingController passwordCon = TextEditingController();
  final TextEditingController passwordAgainCon = TextEditingController();

  final _password = "".obs;
  final _passwordAgain = "".obs;

  final bool passwordEntered = true; // ?
  // bool get passwordEntered => _password.value.isNotEmpty;

  bool get passwordsEqual =>
      _password.value.isNotEmpty && (_password.value == _passwordAgain.value);

  void onNextButtonTap() {
    Get.toNamed(Routes.Maker(nextRoute: Routes.MAKE_PROFILE));
  }

  @override
  void onInit() {
    print("on init!");
    super.onInit();
    passwordCon.addListener(() {
      _password(passwordCon.text);
      print(_password);
    });
    passwordAgainCon.addListener(() {
      _passwordAgain(passwordAgainCon.text);
      print(_passwordAgain);
    });
  }

  @override
  void onClose() {
    super.onClose();
    passwordCon.dispose();
    passwordAgainCon.dispose();
  }
}
