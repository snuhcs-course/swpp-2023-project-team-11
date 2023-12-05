import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/app/presentation/widgets/text_form_fields.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

// ignore: unused_import
import 'email_screen_controller.dart';

class EmailScreen extends GetView<EmailScreenController> {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SimpleAppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4).copyWith(
                    top: 16),
                child: Text(
                  '회원가입을 위해\n학교 이메일을 인증해주세요'.tr,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: MainTextFormField(
                      textEditingController: controller.emailCon,
                      hintText: "학교 이메일 입력".tr,
                      textStyle:
                      const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.w400),
                      verticalPadding: 15,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Obx(() {
                    return SmallButton(
                      text: '인증하기'.tr,
                      onPressed: controller.certable.value? controller.onAuthButtonTap : null,
                    );
                  }),
                ],
              ),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.warningType == 1) {
                  return Text("서울대학교 계정을 사용해주세요 :)".tr,
                      style: TextStyle(
                          color: MyColor.purple,
                          fontSize: 14,
                          fontWeight: FontWeight.w400));
                } else {
                  return const Text("");
                }
              }),
              const SizedBox(height: 10),
              Obx(() {
                if (controller.emailSent.value) {
                  return _buildCodeContainer();
                } else {
                  return const Text("");
                }
              })
            ],
          ),
        ),
      ),
      bottomNavigationBar: Obx(() {
        return BottomNextButton(
            onPressed:
            controller.certSuccess.value ? controller.onNextTap : null);
      }),
    );
  }

  Widget _buildCodeContainer() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(width: 1, color: Colors.black.withOpacity(0.1)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Text("이메일로 전송된 코드를 입력해주세요.".tr,
              style: TextStyle(
                  color: const Color(0xff2d3a45).withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: MainTextFormField(
                    textEditingController: controller.codeCon,
                    hintText: "코드 6자리 입력".tr,
                    textStyle:
                    const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                    verticalPadding: 15,
                  ),
                ),
                const SizedBox(width: 12),
                SmallButton(text: '확인'.tr, onPressed: controller.verifiable.value? controller.onCodeButtonTap:null),
              ],
            ),
          ),
          Obx(() {
            if (controller.warningType == 2) {
              return Text("잘못된 코드에요. 다시 한번 확인해주세요!".tr,
                  style: TextStyle(
                      color: Color(0xff9f75d1),
                      fontSize: 14,
                      fontWeight: FontWeight.w400));
            } else {
              return const Text("");
            }
          }),
          if (controller.certSuccess.value)
            Text("성공적으로 인증되었어요!".tr,
                style: TextStyle(
                    color: MyColor.purple,
                    fontWeight: FontWeight.w600,
                    fontSize: 14))
        ],
      ),
    );
  }
}
