import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/routes/named_routes.dart';

class MakeProfileScreenController extends GetxController{
  TextEditingController nicknameCon = TextEditingController();
  TextEditingController aboutMeCon = TextEditingController();
  final _nickname = "".obs;
  String get nickname => _nickname.value;
  final _aboutMe = "".obs;
  String get aboutMe => _aboutMe.value;

  bool get notEmpty => _nickname.value.isNotEmpty && _aboutMe.value.isNotEmpty;

  void onNextButtonTap() {
    Get.toNamed(Routes.Maker(nextRoute: Routes.PROFILE_SURVEY));
  }

  @override
  void onInit() {
    super.onInit();
    nicknameCon.addListener(() {_nickname(nicknameCon.text);});
    aboutMeCon.addListener(() {_aboutMe(aboutMeCon.text);});
  }

  @override
  void onClose() {
    super.onClose();
    nicknameCon.dispose();
  }


}