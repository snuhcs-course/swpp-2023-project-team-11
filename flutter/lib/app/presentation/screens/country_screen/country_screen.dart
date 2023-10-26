import 'dart:ffi';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/app/presentation/widgets/text_form_fields.dart';

// ignore: unused_import
import 'country_screen_controller.dart';

class CountryScreen extends GetView<CountryScreenController> {
  const CountryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(),
      backgroundColor: Colors.white,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextContainer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Obx(() => _buildOptionContainer(
                    context: context,
                    firstString: '저는\n한국 학생입니다.',
                    secondString: "I'm a Korean student",
                    buttonId: 1)),
                SizedBox(height: 16),
                Obx(() => _buildOptionContainer(
                    context: context,
                    firstString: "I'm an\nexchange student",
                    secondString: "저는 교환학생입니다.",
                    buttonId: 2)),
                SizedBox(height: 16),
                Obx(() {
                  if (controller.tappedButton.value == 2) return _buildCountriesContainer();
                  else return Text("");
                })

              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: Obx(() => _buildNextContainer(context)),
    );
  }

  Container _buildCountriesContainer() {
    return Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Where are you from?",
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff2d3a45),
                            fontWeight: FontWeight.w500),
                      ),
                      SizedBox(height: 16),
                      MainTextFormField(textEditingController: controller.temporaryTextEditingController, hintText: "Your country code")
                    ],
                  ),
                );
  }

  Widget _buildOptionContainer(
      {required BuildContext context,
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
                ? Border.all(color: Color(0xffff9162), width: 2)
                : Border.all(color: Color(0xfff8f1fb), width: 2),
            color: controller.tappedButton.value == buttonId
                ? Colors.white
                : Color(0xfff8f1fb)),
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
                        ? Color(0xffff9162)
                        : Color(0xff2d3a45),
                    fontWeight: FontWeight.w700),
              ),
              SizedBox(
                height: 4,
              ),
              Text(
                secondString,
                style: TextStyle(
                    fontSize: 13,
                    color: Color(0xff2d3a45).withOpacity(0.64),
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
        bottom: MediaQuery.of(context).padding.bottom / 2 + 24,
      ),
      child: MainButton(
        mainButtonType: MainButtonType.key,
        text: '다음',
        onPressed: controller.countryCodeNotEmpty
            ? controller.onNextButtonTap
            : null,
      ),
    );
  }

  Widget _buildTextContainer() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "교환 학생이신가요?\n아니면 한국 학생이신가요?",
            style: TextStyle(
                fontSize: 20,
                color: Color(0xff2d3a45),
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 12,
          ),
          Text(
            "Are you an exchange student?\nOr are you a Korean student?",
            style: TextStyle(
                fontSize: 13,
                color: Color(0xff2d3a45).withOpacity(0.64),
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
