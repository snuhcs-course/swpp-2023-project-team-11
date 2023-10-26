import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/use_cases/email_code_use_case.dart';
import 'package:mobile_app/routes/named_routes.dart';

import '../../../domain/use_cases/email_verify_use_case.dart';

class EmailScreenController extends GetxController{

  final EmailCodeUseCase _emailCodeUseCase;
  final EmailVerifyUseCase _emailVerifyUseCase;

  final Map<String, dynamic> argumentsData = Get.arguments; //currently only contains country code

  final TextEditingController emailCon = TextEditingController();
  final TextEditingController codeCon = TextEditingController();
  final certSuccess = false.obs;
  final emailSent = false.obs;
  final warningType = 0.obs;
  final email = "".obs;
  String _token = "";

  // warningType 1은 제대로 된 이메일이 아니거나 학교 이메일 아닌 경우거나 아무튼 실패한 경우
  // warningType 2는 입력한 코드가 틀리거나 제대로 통신이 안되서 아무튼 실패한 경우

  void onNextTap(){
    print(argumentsData);
    argumentsData["email"] = email.value;
    argumentsData["emailToken"] = _token;
    print(argumentsData);

    Get.toNamed(Routes.Maker(nextRoute: Routes.PASSWORD), arguments: argumentsData);
  }

  void onAuthButtonTap() async {
    email.value = emailCon.text;
    _emailCodeUseCase(email: email.value, onSuccess: (){emailSent.value = true; warningType.value = 0;}, onFail: (){print("fail"); warningType.value = 1;}); // make request to send email with auth code to the user.
  }

  void onCodeButtonTap() async {
    int codeInput = int.parse(codeCon.text);
    _emailVerifyUseCase(codeInput: codeInput, email: email.value, onSuccess: (String token){_token = token; certSuccess.value = true; warningType.value = 0;}, onFail: (){warningType.value = 2;});
  }

  EmailScreenController({
    required EmailCodeUseCase emailCodeUseCase,
    required EmailVerifyUseCase emailVerifyUseCase
  }) : _emailCodeUseCase = emailCodeUseCase, _emailVerifyUseCase = emailVerifyUseCase;

}