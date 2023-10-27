import 'dart:ffi';

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
                Obx(() =>
                    _buildOptionContainer(
                        context: context,
                        firstString: '저는\n한국 학생입니다.',
                        secondString: "I'm a Korean student",
                        buttonId: 1)),
                SizedBox(height: 16),
                Obx(() =>
                    _buildOptionContainer(
                        context: context,
                        firstString: "I'm an\nexchange student",
                        secondString: "저는 교환학생입니다.",
                        buttonId: 2)),
                SizedBox(height: 16),
                Obx(() {
                  if (controller.tappedButton.value == 2)
                    return _buildCountriesContainer();
                  else
                    return Text("");
                })
              ],
            ),
          )
        ],
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
        SizedBox(height: 12),
        _buildCountryList(),
        SizedBox(height: 8,),
        Center(child: SmallButton(onPressed: controller.onCountryNotHereButttontap, text: "My country is not in the list above")),
        SizedBox(height: 16,),
        if (controller.countryNotHere.value) MainTextFormField(
            textEditingController: controller.temporaryTextEditingController,
            hintText: "Your country code")
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
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: country.values.first == controller.tempCountryCode.value ? MyColor
                              .orange_1 : Colors.black.withOpacity(0.1),
                              width: 1)),
                      padding: EdgeInsets.all(6),
                      margin: EdgeInsets.all(4),
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
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: country.values.first == controller.tempCountryCode.value ? MyColor
                              .orange_1 : Colors.black.withOpacity(0.1),
                              width: 1)),
                      padding: EdgeInsets.all(6),
                      margin: EdgeInsets.all(4),
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

            // SizedBox(
            //   height: 50,
            //   child: ListView.separated(
            //     padding: const EdgeInsets.symmetric(
            //         horizontal: 12, vertical: 0),
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) {
            //       final targetEnum = controller.countries[index];
            //       final isSelected = controller.tempCountryCode ==
            //           controller.countries[index].values.first;
            //       return Align(
            //         child: GestureDetector(
            //           onTap: () {
            //             if (isSelected) {
            //               controller.tempCountryCode.value = "0";
            //             } else {
            //               controller.tempCountryCode.value =
            //                   controller.countries[index].values.first;
            //             }
            //           },
            //           child: Container(
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(10),
            //                 border: Border.all(
            //                     color: isSelected ? MyColor.orange_1 : Colors
            //                         .black.withOpacity(0.1), width: 1)),
            //             padding: EdgeInsets.all(6),
            //             child: Text(
            //               controller.countries[index].keys.first,
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: isSelected
            //                     ? FontWeight.bold
            //                     : FontWeight.w500,
            //                 color: isSelected ? MyColor.orange_1 : MyColor
            //                     .textBaseColor,
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //     separatorBuilder: (context, index) {
            //       return const SizedBox(width: 8);
            //     },
            //     itemCount: controller.countries.length,
            //   ),
            // ),
            // SizedBox(
            //   height: 50,
            //   child: ListView.separated(
            //     padding: const EdgeInsets.symmetric(
            //         horizontal: 12, vertical: 0),
            //     scrollDirection: Axis.horizontal,
            //     itemBuilder: (context, index) {
            //       final targetEnum = controller.countries[index];
            //       final isSelected = controller.tempCountryCode ==
            //           controller.countries[index].values.first;
            //       return Align(
            //         child: GestureDetector(
            //           onTap: () {
            //             if (isSelected) {
            //               controller.tempCountryCode.value = "0";
            //             } else {
            //               controller.tempCountryCode.value =
            //                   controller.countries[index].values.first;
            //             }
            //           },
            //           child: Container(
            //             decoration: BoxDecoration(
            //                 borderRadius: BorderRadius.circular(10),
            //                 border: Border.all(
            //                     color: isSelected ? MyColor.orange_1 : Colors
            //                         .black.withOpacity(0.1), width: 1)),
            //             padding: EdgeInsets.all(6),
            //             child: Text(
            //               controller.countries[index].keys.first,
            //               style: TextStyle(
            //                 fontSize: 14,
            //                 fontWeight: isSelected
            //                     ? FontWeight.bold
            //                     : FontWeight.w500,
            //                 color: isSelected ? MyColor.orange_1 : MyColor
            //                     .textBaseColor,
            //               ),
            //             ),
            //           ),
            //         ),
            //       );
            //     },
            //     separatorBuilder: (context, index) {
            //       return const SizedBox(width: 8);
            //     },
            //     itemCount: controller.countries.length,
            //   ),
            // ),
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
        bottom: MediaQuery
            .of(context)
            .padding
            .bottom / 2 + 24,
      ),
      child: MainButton(
        mainButtonType: MainButtonType.key,
        text: '다음',
        onPressed:
        controller.countryCodeNotEmpty ? controller.onNextButtonTap : null,
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
