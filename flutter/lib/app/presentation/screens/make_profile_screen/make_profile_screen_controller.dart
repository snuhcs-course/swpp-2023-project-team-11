import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/routes/named_routes.dart';

class MakeProfileScreenController extends GetxController{
  TextEditingController nicknameCon = TextEditingController();
  final _nickname = "".obs;

  void onNextButtonTap() {
    Get.offAllNamed(Routes.MAIN);
  }


}