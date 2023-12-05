
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/app/presentation/widgets/text_form_fields.dart';

// ignore: unused_import
import '../../../../core/themes/color_theme.dart';
import 'country_screen_controller.dart';

class CountryScreen extends GetView<CountryScreenController> {
  const CountryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const SimpleAppBar(),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextContainer(),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Obx(() =>
                      _buildOptionContainer(
                          context: context,
                          firstString: '저는\n한국 학생입니다.'.tr,
                          secondString: "I'm a Korean student".tr,
                          buttonId: 1)),
                  const SizedBox(height: 16),
                  Obx(() =>
                      _buildOptionContainer(
                          context: context,
                          firstString: "I'm a\nforeign exchange student".tr,
                          secondString: "저는 외국인 교환학생입니다.".tr,
                          buttonId: 2)),
                  const SizedBox(height: 16),
                  Obx(() {
                    if (controller.tappedButton.value == 2) {
                      return _buildCountriesContainer();
                    } else {
                      return const Text("");
                    }
                  })
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Obx(() => _buildNextContainer(context)),
    );
  }

  Widget _buildCountriesContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Where are you from?",
          style: TextStyle(
              fontSize: 14,
              color: Color(0xff2d3a45),
              fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 12),
        _buildCountryList(),
        const SizedBox(height: 12),
        if (controller.countryNotHere.value) MainTextFormField(
            textEditingController: controller.temporaryTextEditingController,
            hintText: "Your country code: ex) 358 for Finland")
        else const SizedBox(height: 40)
      ],
    );
  }

  Widget _buildCountryList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for(var country in controller.countries1) Align(
                child: GestureDetector(
                  onTap: () {
                    if (country.values.first == controller.tempCountryCode.value) {
                      controller.tempCountryCode.value = "0";
                    } else {
                      controller.tempCountryCode.value = country.values.first;
                      controller.countryNotHere.value = false;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: country.values.first == controller.tempCountryCode.value ? MyColor
                            .orange_1 : Colors.black.withOpacity(0.1),
                            width: 1)),
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.all(4),
                    child: Text(
                      country.keys.first,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: country.values.first == controller.tempCountryCode.value
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: country.values.first == controller.tempCountryCode.value ? MyColor.orange_1 : MyColor
                            .textBaseColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
          Row(
            children: [
              for(var country in controller.countries2) Align(
                child: GestureDetector(
                  onTap: () {
                    if (country.values.first == controller.tempCountryCode.value) {
                      controller.tempCountryCode.value = "0";
                    } else {
                      controller.tempCountryCode.value = country.values.first;
                      controller.countryNotHere.value = false;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: country.values.first == controller.tempCountryCode.value ? MyColor
                            .orange_1 : Colors.black.withOpacity(0.1),
                            width: 1)),
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.all(4),
                    child: Text(
                      country.keys.first,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: country.values.first == controller.tempCountryCode.value
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: country.values.first == controller.tempCountryCode.value ? MyColor.orange_1 : MyColor
                            .textBaseColor,
                      ),
                    ),
                  ),
                ),
              ),
              Center(child: ExtraSmallButton(onPressed: controller.onCountryNotHereButttontap, text: "My country is not in this list")),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOptionContainer({required BuildContext context,
    required String firstString,
    required String secondString,
    required int buttonId}) {
    return GestureDetector(
      onTap: () {
        controller.onOptionButtonTap(buttonId);
      },
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: controller.tappedButton.value == buttonId
                ? Border.all(color: const Color(0xffff9162), width: 2)
                : Border.all(color: const Color(0xfff8f1fb), width: 2),
            color: controller.tappedButton.value == buttonId
                ? Colors.white
                : const Color(0xfff8f1fb)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                firstString,
                style: TextStyle(
                    fontSize: 20,
                    color: controller.tappedButton.value == buttonId
                        ? const Color(0xffff9162)
                        : const Color(0xff2d3a45),
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 4,
              ),
              Text(
                secondString,
                style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xff2d3a45).withOpacity(0.64),
                    fontWeight: FontWeight.w400),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNextContainer(BuildContext context) {
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 24).copyWith(
        bottom: MediaQuery
            .of(context)
            .padding
            .bottom / 2 + 24,
      ),
      child: MainButton(
        mainButtonType: MainButtonType.key,
        text: '다음'.tr,
        onPressed:
        controller.countryCodeNotEmpty ? controller.onNextButtonTap : null,
      ),
    );
  }

  Widget _buildTextContainer() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "한국 학생이신가요,\n아니면 외국인 교환 학생이신가요?".tr,
            style: TextStyle(
                fontSize: 20,
                color: Color(0xff2d3a45),
                fontWeight: FontWeight.w700),
          ),
          const SizedBox(
            height: 12,
          ),
          Text(
            "Are you a Korean student,\n or a foreign exchange student?".tr,
            style: TextStyle(
                fontSize: 13,
                color: const Color(0xff2d3a45).withOpacity(0.64),
                fontWeight: FontWeight.w400),
          ),
        ],
      ),
    );
  }
}

// GetPage(
//   name: ,
//   page: () => const CountryScreen(),
//   binding: CountryScreenBinding(),
// )
