import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/routes/named_routes.dart';

class MakeProfileScreenController extends GetxController{
  TextEditingController nicknameCon = TextEditingController();
  final argumentsData = Get.arguments;
  final _nickname = "".obs;

  void onNextButtonTap() {
    // argumentsData["nickname"] = _nickname.value;
    Get.toNamed(Routes.Maker(nextRoute: Routes.PROFILE_SURVEY));
  }

  @override
  void onInit() {
    super.onInit();
    nicknameCon.addListener(() {_nickname(nicknameCon.text);});
  }

  @override
  void onClose() {
    super.onClose();
    nicknameCon.dispose();
  }


}