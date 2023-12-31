import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/app/presentation/widgets/text_form_fields.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

class SignInBottomSheet extends StatelessWidget {
  final TextEditingController emailCon;
  final TextEditingController passwordCon;
  final void Function() onSignInRequested;
  final void Function() onSignUpRequested;
  final RxBool needWarning;

  const SignInBottomSheet({
    super.key,
    required this.emailCon,
    required this.passwordCon,
    required this.onSignInRequested,
    required this.onSignUpRequested,
    required this.needWarning
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(10),
          topLeft: Radius.circular(10),
        ),
        color: Colors.white,
      ),
      padding: const EdgeInsets.all(20).copyWith(
        top: 24,
        bottom: MediaQuery
            .of(context)
            .padding
            .bottom / 2 + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MainTextFormField(
              textEditingController: emailCon,
              hintText: "이메일 입력".tr,
              titleText: "학교 이메일 (university email)".tr,
              key: const Key("emailForm"),
            ),
            const SizedBox(height: 16),
            MainTextFormField(
              textEditingController: passwordCon,
              hintText: "비밀번호 입력".tr,
              titleText: "비밀번호 (password)".tr,
              obscureText: true,
              key: const Key("passwordForm"),
            ),
            const SizedBox(height: 7),
            Obx(() {
              if(needWarning.value) {
                return Text("로그인에 실패했어요. 이메일, 비밀번호를 다시 확인해주세요!".tr, style: TextStyle(color: MyColor.purple, fontWeight: FontWeight.w500, fontSize: 12),);
              } else {
                return const SizedBox(height: 7);
              }
            }),
            const SizedBox(height: 14),
            MainButton(
              mainButtonType: MainButtonType.key,
              text: '로그인'.tr,
              onPressed: onSignInRequested,
              key: const Key("finalLogin"),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("아직 회원이 아닌신가요?".tr),
                TextButton(
                  onPressed: onSignUpRequested,
                  child: Text(
                    "회원가입".tr,
                    style: TextStyle(fontSize: 14, color: Color(0xffff733d)),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
