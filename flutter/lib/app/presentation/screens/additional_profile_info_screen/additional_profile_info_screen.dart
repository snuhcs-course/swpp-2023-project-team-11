import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/app/presentation/widgets/text_form_fields.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

// ignore: unused_import
import 'additional_profile_info_screen_controller.dart';

class AdditionalProfileInfoScreen
    extends GetView<AdditionalProfileInfoScreenController> {
  const AdditionalProfileInfoScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SimpleAppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('회원정보 입력',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              const Text(
                  "*입력하신 회원정보는 다른 사용자들에게 공개되지 않고 회원관리 및 언어교환 상대 추천을 위해 내부적으로만 이용됩니다.",
                  style: TextStyle(color: MyColor.textBaseColor, fontSize: 12)),

              const SizedBox(height: 20),
              const Text("생년월일", style: TextStyle(color: Color(0xff2d3a45),
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
              const SizedBox(height: 12),
              MainTextFormField(textEditingController: controller.birthdayCon,
                  hintText: "  YYYYMMDD         예시) 19990131"),

              const SizedBox(height: 30),
              SizedBox(
                height: 80,
                child: GridView.count(crossAxisCount: 2,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("성별", style: TextStyle(color: Color(0xff2d3a45),
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                        Obx(() {
                          return DropdownButton(
                              value: controller.gender.value,
                              items: controller.genderMap.keys.map(
                                      (genderOption) =>
                                      DropdownMenuItem(
                                          value: genderOption.toString(),
                                          child: Text(genderOption)))
                                  .toList(), onChanged: (genderOption) {
                            controller.gender.value = genderOption!;
                          });
                        }),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text("입학 연도", style: TextStyle(color: Color(0xff2d3a45),
                            fontWeight: FontWeight.w600,
                            fontSize: 16)),
                        Obx(() {
                          return DropdownButton(
                              value: controller.admission.value,
                              items: controller.admissionYears.map(
                                      (year) =>
                                      DropdownMenuItem(
                                          value: year.toString(),
                                          child: Text("$year")))
                                  .toList(), onChanged: (year) {
                            controller.admission.value = year!;
                          });
                        }),
                      ],
                    ),
                  ],),
              ),

              const SizedBox(height: 10),
              const Text("학과", style: TextStyle(color: Color(0xff2d3a45),
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
              _buildDepartmentSelection(),
              const SizedBox(height: 20),

              const Text("Mbti", style: TextStyle(color: MyColor.purple,
                  fontWeight: FontWeight.w600,
                  fontSize: 16)),
              Obx(() {
                return DropdownButton(
                    value: controller.selectedMbti.value,
                    items: controller.mbtiMap.keys.map(
                            (mbti) =>
                            DropdownMenuItem(
                                value: mbti,
                                child: Text(mbti)))
                        .toList(), onChanged: (mbti) {
                  controller.selectedMbti.value = mbti.toString();
                });
              }),



            ],
          ),
        ),
      ),
      bottomNavigationBar:
      Obx(() {
        return BottomNextButton(
            onPressed: controller.allSet ? controller.onNextButtonTap : null);
      }),
    );
  }


  Widget _buildDepartmentSelection() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Obx(() =>
            DropdownButton<String>(
              value: controller.selectedCollege.value,
              items: controller.colleges
                  .map((college) =>
                  DropdownMenuItem(
                    value: college,
                    child: Text(college, style: const TextStyle(
                        color: Color(0xff2d3a45),
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
                  ))
                  .toList(),
              onChanged: (value) {
                controller.selectedCollege.value = value!;
                controller.selectedDepartment.value = '학과 선택';
              },
            )),
        const SizedBox(height: 12),
        Obx(() =>
            DropdownButton<String>(
              value: controller.selectedDepartment.value,
              items: controller.selectedCollege.value == '단과대학 선택'
                  ? []
                  : controller.departmentMap[controller.selectedCollege.value]!
                  .map((department) =>
                  DropdownMenuItem(
                    value: department,
                    child: Text(department, style: const TextStyle(
                        color: Color(0xff2d3a45),
                        fontWeight: FontWeight.w500,
                        fontSize: 16)),
                  ))
                  .toList(),
              onChanged: (value) {
                controller.selectedDepartment.value = value!;
              },
            )),
      ],
    );
  }
}

// GetPage(
//   name: ,
//   page: () => const AdditionalProfileInfoScreen(),
//   binding: AdditionalProfileInfoScreenBinding(),
// )
