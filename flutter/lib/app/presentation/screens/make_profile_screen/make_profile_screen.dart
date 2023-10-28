import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

// ignore: unused_import
import '../../widgets/text_form_fields.dart';
import 'make_profile_screen_controller.dart';

class MakeProfileScreen extends GetView<MakeProfileScreenController> {
  const MakeProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: "프로필 생성",
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox.fromSize(
                    child: Image.asset('assets/images/snek_profile_img_1.webp'),
                    size: Size.fromRadius(90),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                  child: Text(
                    "작성된 프로필은 다른 유저들이 볼 수 있어요",
                    style: TextStyle(
                        fontSize: 14,
                        color: MyColor.purple,
                        fontWeight: FontWeight.w500),
                  )),
              SizedBox(height: 12),
              Text("활동할 닉네임을 입력해주세요",
                  style: TextStyle(
                      color: Color(0xff2d3a45),
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
              SizedBox(height: 8),
              MainTextFormField(
                textEditingController: controller.nicknameCon,
                hintText: "닉네임 입력",
                textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                verticalPadding: 15,
              ),
              SizedBox(height: 8),
              Text("닉네임은 최대 12자까지 가능해요.",
                  style: TextStyle(
                      color: Color(0xff2d3a45).withOpacity(0.64),
                      fontWeight: FontWeight.w400,
                      fontSize: 14)),
              SizedBox(height: 20),
              Text("자신을 소개하는 문장을 입력해주세요",
                  style: TextStyle(
                      color: Color(0xff2d3a45),
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
              SizedBox(height: 8),
              MainTextFormField(
                textEditingController: controller.aboutMeCon,
                hintText: "자기소개 입력",
                textStyle: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                verticalPadding: 15,
              ),
              SizedBox(height: 8),
              Text("프로필은 나중에도 수정이 가능하니 부담 갖지 말고 적어주세요!",
                  style: TextStyle(
                      color: Color(0xff2d3a45).withOpacity(0.64),
                      fontWeight: FontWeight.w400,
                      fontSize: 14)),
              SizedBox(height: 12),
              if (controller.isForeign) const Text("주로 사용하는 언어",
                  style: TextStyle(
                      color: Color(0xff2d3a45),
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
              if (controller.isForeign) Obx(() {
                return _buildLanguageList();
              }),
              if (controller.isForeign) SizedBox(height: 12),
              (controller.isForeign)? const Text("주언어 외 사용 가능 언어",
                  style: TextStyle(
                      color: Color(0xff2d3a45),
                      fontWeight: FontWeight.w500,
                      fontSize: 14)) : const Text("교환을 희망하는 언어",
                  style: TextStyle(
                      color: Color(0xff2d3a45),
                      fontWeight: FontWeight.w500,
                      fontSize: 14)),
              Obx(() {
                return _buildLanguagesList();
              }),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return BottomNextButton(
            onPressed: controller.notEmpty ? controller.onNextButtonTap : null);
      }),
    );
  }

  // Widget _buildProfilePhoto() {
  //   return Center(
  //     child: Column(
  //       children: [
  //         Container(
  //           width: 180,
  //           height: 180,
  //           decoration: BoxDecoration(
  //               borderRadius: BorderRadius.circular(12),
  //               border:
  //               Border.all(color: Colors.black.withOpacity(0.2), width: 1),
  //               color: Colors.grey),
  //         ),
  //         Transform.translate(
  //           offset: Offset(0, -20),
  //           child: Container(
  //             width: 140,
  //             height: 48,
  //             decoration: BoxDecoration(
  //                 borderRadius: BorderRadius.circular(10),
  //                 border: Border.all(color: Color(0xffff9162), width: 1.5),
  //                 color: Colors.white,
  //                 boxShadow: [
  //                   BoxShadow(
  //                       color: Colors.black.withOpacity(0.12),
  //                       blurRadius: 4,
  //                       offset: Offset(0, 4))
  //                 ]),
  //             child: Center(
  //                 child: Text(
  //                   "사진 업로드",
  //                   style: TextStyle(
  //                       color: Color(0xffff733d),
  //                       fontWeight: FontWeight.w700,
  //                       fontSize: 18),
  //                 )),
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget _buildLanguageList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for(var language in controller.languages1) Align(
                child: GestureDetector(
                  onTap: () {
                    if (language.keys.first ==
                        controller.selectedMainLanguage.value) {
                      controller.selectedMainLanguage.value = "";
                    } else {
                      controller.selectedMainLanguage.value =
                          language.keys.first;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: language.keys.first ==
                            controller.selectedMainLanguage.value ? MyColor
                            .orange_1 : Colors.black.withOpacity(0.1),
                            width: 1)),
                    padding: EdgeInsets.all(6),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      language.keys.first,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: language.keys.first ==
                            controller.selectedMainLanguage.value
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: language.keys.first ==
                            controller.selectedMainLanguage.value ? MyColor
                            .orange_1 : MyColor
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
              for(var language in controller.languages2) Align(
                child: GestureDetector(
                  onTap: () {
                    if (language.keys.first ==
                        controller.selectedMainLanguage.value) {
                      controller.selectedMainLanguage.value = "";
                    } else {
                      controller.selectedMainLanguage.value =
                          language.keys.first;
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: language.keys.first ==
                            controller.selectedMainLanguage.value ? MyColor
                            .orange_1 : Colors.black.withOpacity(0.1),
                            width: 1)),
                    padding: EdgeInsets.all(6),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      language.keys.first,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: language.keys.first ==
                            controller.selectedMainLanguage.value
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: language.keys.first ==
                            controller.selectedMainLanguage.value ? MyColor
                            .orange_1 : MyColor
                            .textBaseColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),

        ],
      ),
    );
  }
  Widget _buildLanguagesList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              for(var language in controller.languages1) Align(
                child: GestureDetector(
                  onTap: () {
                    if (controller.selectedLanguages.value.contains(language.values.first)) {
                      controller.selectedLanguages.value.remove(language.values.first);
                      controller.selectedLanguages.refresh();
                    } else {
                      controller.selectedLanguages.value.add(language.values.first);
                      controller.selectedLanguages.refresh();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: controller.selectedLanguages.value.contains(language.values.first) ? MyColor
                            .orange_1 : Colors.black.withOpacity(0.1),
                            width: 1)),
                    padding: EdgeInsets.all(6),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      language.keys.first,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: controller.selectedLanguages.value.contains(language.values.first)
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: controller.selectedLanguages.value.contains(language.values.first) ? MyColor
                            .orange_1 : MyColor
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
              for(var language in controller.languages2) Align(
                child: GestureDetector(
                  onTap: () {
                    if (controller.selectedLanguages.value.contains(language.values.first)) {
                      controller.selectedLanguages.value.remove(language.values.first);
                      controller.selectedLanguages.refresh();
                    } else {
                      controller.selectedLanguages.value.add(language.values.first);
                      controller.selectedLanguages.refresh();
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: controller.selectedLanguages.value.contains(language.values.first) ? MyColor
                            .orange_1 : Colors.black.withOpacity(0.1),
                            width: 1)),
                    padding: EdgeInsets.all(6),
                    margin: EdgeInsets.all(4),
                    child: Text(
                      language.keys.first,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: controller.selectedLanguages.value.contains(language.values.first)
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: controller.selectedLanguages.value.contains(language.values.first) ? MyColor
                            .orange_1 : MyColor
                            .textBaseColor,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),

        ],
      ),
    );
  }
}

// GetPage(
//   name: ,
//   page: () => const MakeProfileScreen(),
//   binding: MakeProfileScreenBinding(),
// )
