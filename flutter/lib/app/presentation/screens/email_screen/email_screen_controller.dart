import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/use_cases/email_code_use_case.dart';
import 'package:mobile_app/routes/named_routes.dart';

import '../../../domain/use_cases/email_verify_use_case.dart';

class EmailScreenController extends GetxController{

  final EmailCodeUseCase _emailCodeUseCase;
  final EmailVerifyUseCase _emailVerifyUseCase;

  final TextEditingController emailCon = TextEditingController();
  final TextEditingController codeCon = TextEditingController();
  final certSuccess = true.obs; //
  final emailSent = false.obs;
  final warningType = 0.obs;
  final _email = "".obs;
  String get email => _email.value;
  final _token = "".obs;
  String get emailToken => _token.value;

  // warningType 1은 제대로 된 이메일이 아니거나 학교 이메일 아닌 경우거나 아무튼 실패한 경우
  // warningType 2는 입력한 코드가 틀리거나 제대로 통신이 안되서 아무튼 실패한 경우

  void onNextTap(){
    Get.toNamed(Routes.Maker(nextRoute: Routes.PASSWORD));
  }

  void onAuthButtonTap() async {
    _email.value = emailCon.text;
    _emailCodeUseCase(email: email, onSuccess: (){emailSent.value = true; warningType.value = 0;}, onFail: (){print("fail"); warningType.value = 1;}); // make request to send email with auth code to the user.
  }

  void onCodeButtonTap() async {
    int codeInput = int.parse(codeCon.text);
    _emailVerifyUseCase(codeInput: codeInput, email: email, onSuccess: (String token){_token.value = token; certSuccess.value = true; warningType.value = 0;}, onFail: (){warningType.value = 2;});
  }

  EmailScreenController({
    required EmailCodeUseCase emailCodeUseCase,
    required EmailVerifyUseCase emailVerifyUseCase
  }) : _emailCodeUseCase = emailCodeUseCase, _emailVerifyUseCase = emailVerifyUseCase;

}