import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/routes/named_routes.dart';

class CountryScreenController extends GetxController {
  final tappedButton = 0.obs;

  final temporaryTextEditingController = TextEditingController();
  final tempCountryCode = "0".obs;

  int get countryCode => int.parse(tempCountryCode.value);
  bool get countryCodeNotEmpty => tempCountryCode.isNotEmpty && tempCountryCode.value != "0";
  final countryNotHere = false.obs;

  final List<Map<String, String>> countries1 = [
    {"United States 🇺🇸": "1"},
    {"Indonesia 🇮🇩": "62"},

    {"Brazil 🇧🇷": "55"},
    {"United Kingdom 🇬🇧": "44"},
    {"Nigeria 🇳🇬": "234"},
    {"Australia 🇦🇺": "61"},
    {"Bangladesh 🇧🇩": "880"},
    {"Russia 🇷🇺": "7"},
    {"Pakistan 🇵🇰": "92"},
    {"Turkey 🇹🇷": "90"},
    {"Iran 🇮🇷": "98"},
    {"Congo (DRC) 🇨🇩": "243"},
    {"France 🇫🇷": "33"},
    {"Thailand 🇹🇭": "66"},



    {"Ukraine 🇺🇦": "380"},
    {"Tanzania 🇹🇿": "255"},

  ];
  final List<Map<String, String>> countries2 = [
    {"China 🇨🇳": "86"},
    {"India 🇮🇳": "91"},

    {"Mexico 🇲🇽": "52"},
    {"Japan 🇯🇵": "81"},
    {"Ethiopia 🇪🇹": "251"},
    {"New Zealand 🇳🇿": "64"},
    {"Philippines 🇵🇭": "63"},
    {"Egypt 🇪🇬": "20"},
    {"Germany 🇩🇪": "49"},
    {"Netherlands 🇳🇱": "31"},

    {"Italy 🇮🇹": "39"},
    {"South Africa 🇿🇦": "27"},
    {"Myanmar 🇲🇲": "95"},
    {"Sweden 🇸🇪": "46"},
    {"Colombia 🇨🇴": "57"},
    {"Spain 🇪🇸": "34"},
    {"Argentina 🇦🇷": "54"}

  ];


  void onOptionButtonTap(int tappedButton) {
    this.tappedButton.value = tappedButton;
    if (tappedButton == 1) tempCountryCode.value = "82";
    else tempCountryCode.value = "0";
  }

  void onNextButtonTap() {
    Get.toNamed(Routes.Maker(nextRoute: Routes.EMAIL));
  }

  void onCountryNotHereButttontap() {
    this.countryNotHere.value = true;
  }

  @override
  void onInit() {
    super.onInit();
    temporaryTextEditingController.addListener(() {
      tempCountryCode(temporaryTextEditingController.text);
    });

  }

  @override
  void onClose() {
    super.onClose();
    temporaryTextEditingController.dispose();
  }
}
