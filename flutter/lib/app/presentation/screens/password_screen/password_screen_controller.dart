import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/routes/named_routes.dart';

class PasswordScreenController extends GetxController {
  final TextEditingController passwordCon = TextEditingController();
  final TextEditingController passwordAgainCon = TextEditingController();

  final argumentsData = Get.arguments;
  final _password = "".obs;
  final _passwordAgain = "".obs;

  bool get passwordEntered => _password.value.isNotEmpty && (_password.value.length >= 6) && (_password.value.length <= 20);

  bool get passwordsEqual =>
      _password.value.isNotEmpty && (_password.value == _passwordAgain.value);

  void onNextButtonTap() {
    argumentsData["password"] = _password.value;
    Get.toNamed(Routes.Maker(nextRoute: Routes.MAKE_PROFILE), arguments: argumentsData);
  }

  @override
  void onInit() {
    super.onInit();
    passwordCon.addListener(() {
      _password(passwordCon.text);
    });
    passwordAgainCon.addListener(() {
      _passwordAgain(passwordAgainCon.text);
    });
  }

  @override
  void onClose() {
    super.onClose();
    passwordCon.dispose();
    passwordAgainCon.dispose();
  }
}
