import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/routes/named_routes.dart';

class EmailScreenController extends GetxController{
  final TextEditingController emailCon = TextEditingController();
  final TextEditingController codeCon = TextEditingController();
  final certSuccess = true; //need to fix
  final emailSent = true; //need to fix

  void temporaryOnTap(){
    Get.toNamed(Routes.Maker(nextRoute: Routes.PASSWORD));
  }
}