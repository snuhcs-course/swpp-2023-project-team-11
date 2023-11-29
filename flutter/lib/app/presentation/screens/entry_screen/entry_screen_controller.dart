import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/use_cases/automatic_sign_in_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/sign_in_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/sign_up_use_case.dart';
import 'package:mobile_app/app/presentation/screens/entry_screen/widgets/sign_in_bottom_sheet.dart';
import 'package:mobile_app/core/utils/loading_util.dart';
import 'package:mobile_app/routes/named_routes.dart';

class EntryScreenController extends GetxController {
  final SignInUseCase _signInUseCase;

  final TextEditingController emailCon = TextEditingController();
  final TextEditingController passwordCon = TextEditingController();

  final signinWarning = false.obs;

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(const Duration(milliseconds: 200));
  }

  void onSignUpButtonTap() {
    Get.toNamed(Routes.Maker(nextRoute: Routes.COUNTRY));
  }

  void onSignInButtonTap() {
    Get.bottomSheet(
      SignInBottomSheet(
        emailCon: emailCon,
        passwordCon: passwordCon,
        onSignInRequested: _signIn,
        onSignUpRequested: _signUp,
        needWarning: signinWarning,
      ),
    );
  }

  void onSignInSuccess(User user) {
    print("on sigin in success");
    Get.offAllNamed(Routes.MAIN, arguments: user);
  }

  void _signIn() {
    LoadingUtil.withLoadingOverlay(asyncFunction: () async {
      await _signInUseCase.call(
          email: emailCon.text,
          password: passwordCon.text,
          onFail: () {
            signinWarning.value = true;
            Timer(const Duration(seconds: 3), () {
              signinWarning.value = false;
            });
            print("Sign in fail");
          },
          onSuccess: (user) {
            onSignInSuccess(user);
          });
    });
  }

  void _signUp() {
    Get.back();
    Get.toNamed(Routes.Maker(nextRoute: Routes.COUNTRY));
  }

  EntryScreenController({
    required SignUpUseCase signUpUseCase,
    required SignInUseCase signInUseCase,
  }) : _signInUseCase = signInUseCase;
}
