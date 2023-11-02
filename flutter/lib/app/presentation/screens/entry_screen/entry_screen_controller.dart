import 'package:flutter/cupertino.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/use_cases/sign_in_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/sign_up_use_case.dart';
import 'package:mobile_app/app/presentation/screens/entry_screen/widgets/sign_in_bottom_sheet.dart';
import 'package:mobile_app/routes/named_routes.dart';

class EntryScreenController extends GetxController {
  final SignInUseCase _signInUseCase;
  final SignUpUseCase _signUpUseCase;

  final TextEditingController emailCon = TextEditingController();
  final TextEditingController passwordCon = TextEditingController();

  @override
  void onReady() async {
    super.onReady();
    await Future.delayed(const Duration(milliseconds: 200));
    FlutterNativeSplash.remove();
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
      ),
    );
  }

  void onSignInSuccess(){
    Get.offAllNamed(Routes.MAIN);
  }

  void _signIn() {
    _signInUseCase.call(email: emailCon.text, password: passwordCon.text, onFail: (){print("Sign in fail");}, onSuccess: (){onSignInSuccess();});
  }

  void _signUp() {

  }

  EntryScreenController({
    required SignUpUseCase signUpUseCase,
    required SignInUseCase signInUseCase,
  })  : _signUpUseCase = signUpUseCase,
        _signInUseCase = signInUseCase;
}
