import 'dart:ui';

import 'package:get/get.dart';

class MyTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "en" : {
      "간식보다 재밌는 언어교환" : "Language exchange\nthat's more fun than snacks"
    },
  };
}

abstract class MyLanguageUtil {
  static LanguageMode _currentLanguage = LanguageMode.kr;
  static Locale get getLocale => Locale(_currentLanguage.name);
  static void toggle(){
    if (_currentLanguage==LanguageMode.kr) {
      _currentLanguage = LanguageMode.en;
      Get.updateLocale(Locale(LanguageMode.en.name));
    } else {
      _currentLanguage = LanguageMode.kr;
      Get.updateLocale(Locale(LanguageMode.kr.name));
    }

  }
}

enum LanguageMode {
  en,
  kr
}