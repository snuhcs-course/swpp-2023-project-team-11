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
    {"영어": Language.english},
    {"스페인어": Language.spanish},
    {"중국어": Language.chinese},
    {"아랍어": Language.arabic},
    {"힌디어": Language.hindi},
    {"태국어": Language.thai},
    {"그리스어": Language.greek},
    {"베트남어": Language.vietnamese},
    {"핀란드어": Language.finnish},
    {"히브리어": Language.hebrew},
  ];
  final List<Map<String, Language>> languages2 = [
    {"프랑스어": Language.french},
    {"일본어": Language.japanese},
    {"독일어": Language.german},
    {"러시아어": Language.russian},
    {"포르투갈어": Language.portuguese},
    {"이탈리아어": Language.italian},
    {"네덜란드어": Language.dutch},
    {"스웨덴어": Language.swedish},
    {"터키어": Language.turkish},
  ];
  final Map<String, Language> languageMap = {
    "한국어": Language.korean,
    "영어": Language.english,
    "스페인어": Language.spanish,
    "중국어": Language.chinese,
    "아랍어": Language.arabic,
    "프랑스어": Language.french,
    "독일어": Language.german,
    "일본어": Language.japanese,
    "러시아어": Language.russian,
    "포르투갈어": Language.portuguese,
    "이탈리아어": Language.italian,
    "네덜란드어": Language.dutch,
    "스웨덴어": Language.swedish,
    "터키어": Language.turkish,
    "히브리어": Language.hebrew,
    "힌디어": Language.hindi,
    "태국어": Language.thai,
    "그리스어": Language.greek,
    "베트남어": Language.vietnamese,
    "핀란드어": Language.finnish,
  };

  bool get notEmpty => _nickname.value.isNotEmpty && _aboutMe.value.isNotEmpty
                      && (selectedMainLanguage.value != "") && (selectedLanguages.value.length != 0);

  void onNextButtonTap() {
    print("${nickname} ${aboutMe} ${selectedMainLanguage} ${selectedLanguages}");
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