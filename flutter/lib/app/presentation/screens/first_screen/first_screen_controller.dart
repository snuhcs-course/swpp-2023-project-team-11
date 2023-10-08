import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/routes/named_routes.dart';

class FirstScreenController extends GetxController{
  final TextEditingController idCon = TextEditingController();
  final TextEditingController pwdCon = TextEditingController();

  final _id = "".obs;
  final _pwd = "".obs;

  bool get canLogin => _id.value.isNotEmpty && _pwd.value.isNotEmpty;

  void onSignUpButtonTap() {
    // 우리 플젝에서 페이지 이동할 때에는 항상 아래 형식을 따른다
    // toNamed에는 string이 들어가는데, Routes.Maker 메소드를
    // 활용하여 다음 화면의 url을 알아서 조합하여 만들어준다.
    Get.toNamed(Routes.Maker(nextRoute: Routes.SIGN_UP));
  }

  @override
  void onInit() {
    super.onInit();
    idCon.addListener(() {
      _id(idCon.text);
    });
    pwdCon.addListener(() {
      _pwd(pwdCon.text);
    });
  }

  @override
  void onClose() {
    super.onClose();
    // 이거 해줘야 메모리 누수를 막을 수 있음
    idCon.dispose();
    pwdCon.dispose();
  }
}