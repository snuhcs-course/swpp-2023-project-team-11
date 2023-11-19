import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/app/presentation/widgets/text_form_fields.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

// ignore: unused_import
import 'password_screen_controller.dart';

class PasswordScreen extends GetView<PasswordScreenController> {
  const PasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SimpleAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('사용할 비밀번호를\n입력해주세요'.tr,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                )),
            const SizedBox(height: 8),
            Text("*6자 이상, 20자 이하의 숫자/영문".tr,
                style: TextStyle(
                    color: const Color(0xff2d3a45).withOpacity(0.8),
                    fontWeight: FontWeight.w400,
                    fontSize: 14)),
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 20),
              child: MainTextFormField(
                obscureText: true,
                textEditingController: controller.passwordCon,
                hintText: '비밀번호 입력'.tr,
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                verticalPadding: 15,
              ),
            ),
            Obx(() => controller.passwordEntered
                ? _buildPasswordAgainContainer()
                : const Text(""))
          ],
        ),
      ),
      bottomNavigationBar: Obx(() {
        return BottomNextButton(
            onPressed:
                controller.passwordsEqual ? controller.onNextButtonTap : null);
      }),
    );
  }

  Widget _buildPasswordAgainContainer() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(width: 1, color: Colors.black.withOpacity(0.1)))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 20),
          Text("비밀번호를 재입력해주세요.".tr,
              style: TextStyle(
                  color: const Color(0xff2d3a45).withOpacity(0.8),
                  fontWeight: FontWeight.w500,
                  fontSize: 14)),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: MainTextFormField(
              obscureText: true,
              textEditingController: controller.passwordAgainCon,
              hintText: "비밀번호 재입력".tr,
              textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
              verticalPadding: 15,
            ),
          ),
          controller.passwordsEqual
              ? Text(
                  "비밀번호가 일치해요!".tr,
                  style: TextStyle(
                      color: MyColor.purple,
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                )
              : Text(
                  "비밀번호가 일치하지 않아요".tr,
                  style: TextStyle(
                      color: const Color(0xff2d3a45).withOpacity(0.36),
                      fontWeight: FontWeight.w600,
                      fontSize: 14),
                )
        ],
      ),
    );
  }
}

// GetPage(
//   name: ,
//   page: () => const PasswordScreen(),
//   binding: PasswordScreenBinding(),
// )
