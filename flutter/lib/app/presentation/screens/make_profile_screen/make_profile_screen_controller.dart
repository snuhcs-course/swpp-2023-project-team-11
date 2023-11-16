import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/presentation/screens/country_screen/country_screen_controller.dart';
import 'package:mobile_app/routes/named_routes.dart';

class MakeProfileScreenController extends GetxController{
  TextEditingController nicknameCon = TextEditingController();
  TextEditingController aboutMeCon = TextEditingController();
  final _nickname = "".obs;
  String get nickname => _nickname.value;
  final _aboutMe = "".obs;
  String get aboutMe => _aboutMe.value;

  final bool isForeign = Get.find<CountryScreenController>().countryCode != 82;
  final selectedMainLanguage = "".obs;
  Language get mainLanguage => languageMap[selectedMainLanguage]!;
  final RxList<Language> selectedLanguages = <Language>[].obs;

  final List<Map<String, Language>> languages1 = [
    {"영어".tr: Language.english},
    {"스페인어".tr: Language.spanish},
    {"중국어".tr: Language.chinese},
    {"아랍어".tr: Language.arabic},
    {"힌디어".tr: Language.hindi},
    {"태국어".tr: Language.thai},
    {"그리스어".tr: Language.greek},
    {"베트남어".tr: Language.vietnamese},
    {"핀란드어".tr: Language.finnish},
    {"히브리어".tr: Language.hebrew},
  ];
  final List<Map<String, Language>> languages2 = [
    {"프랑스어".tr: Language.french},
    {"일본어".tr: Language.japanese},
    {"독일어".tr: Language.german},
    {"러시아어".tr: Language.russian},
    {"포르투갈어".tr: Language.portuguese},
    {"이탈리아어".tr: Language.italian},
    {"네덜란드어".tr: Language.dutch},
    {"스웨덴어".tr: Language.swedish},
    {"터키어".tr: Language.turkish},
  ];
  final Map<String, Language> languageMap = {
    "한국어".tr: Language.korean,
    "영어".tr: Language.english,
    "스페인어".tr: Language.spanish,
    "중국어".tr: Language.chinese,
    "아랍어".tr: Language.arabic,
    "프랑스어".tr: Language.french,
    "독일어".tr: Language.german,
    "일본어".tr: Language.japanese,
    "러시아어".tr: Language.russian,
    "포르투갈어".tr: Language.portuguese,
    "이탈리아어".tr: Language.italian,
    "네덜란드어".tr: Language.dutch,
    "스웨덴어".tr: Language.swedish,
    "터키어".tr: Language.turkish,
    "히브리어".tr: Language.hebrew,
    "힌디어".tr: Language.hindi,
    "태국어".tr: Language.thai,
    "그리스어".tr: Language.greek,
    "베트남어".tr: Language.vietnamese,
    "핀란드어".tr: Language.finnish,
  };

  bool get notEmpty => _nickname.value.isNotEmpty && (_nickname.value.length <= 8) && _aboutMe.value.isNotEmpty
                      && (selectedMainLanguage.value != "") && (selectedLanguages.value.isNotEmpty);

  void onNextButtonTap() {
    print("$nickname $aboutMe $selectedMainLanguage $selectedLanguages");
    Get.toNamed(Routes.Maker(nextRoute: Routes.PROFILE_SURVEY));
  }

  @override
  void onInit() {
    super.onInit();
    if (!isForeign) selectedMainLanguage.value = "korean";
    nicknameCon.addListener(() {_nickname(nicknameCon.text);});
    aboutMeCon.addListener(() {_aboutMe(aboutMeCon.text);});
  }


  @override
  void onClose() {
    super.onClose();
    nicknameCon.dispose();
  }


}