
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/use_cases/automatic_sign_in_use_case.dart';
import 'package:mobile_app/core/constants/system_strings.dart';
import 'package:mobile_app/core/utils/translation.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/routes/named_routes.dart';

class SplashScreenController extends GetxController {
  final AutomaticSignInUseCase _automaticSignInUseCase;

  SplashScreenController({
    required AutomaticSignInUseCase automaticSignInUseCase,
  }) : _automaticSignInUseCase = automaticSignInUseCase;

  @override
  void onReady() {
    print("splash on ready");
    if ((sp.containsKey(language_setting)) && (sp.getString(language_setting) == 'en') && MyLanguageUtil.isKr) MyLanguageUtil.toggle();
    _automaticSignInUseCase.call(
      onFail: () {
        Get.offAllNamed(Routes.ENTRY);
      },
      onSuccess: (user) {
        Get.offAllNamed(Routes.MAIN, arguments: user);
      },
    );
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
    Future.delayed(const Duration(milliseconds: 300)).then((value) => FlutterNativeSplash.remove());
  }
}
