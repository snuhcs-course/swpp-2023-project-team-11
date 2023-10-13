import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/app/presentation/widgets/text_form_fields.dart';

// ignore: unused_import
import 'email_screen_controller.dart';

class EmailScreen extends GetView<EmailScreenController> {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const SimpleAppBar(),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                 Padding(
                  padding: EdgeInsets.symmetric(horizontal: 4).copyWith(top: 16),
                  child: const Text(
                    '회원가입을 위해\n학교 이메일을 인증해주세요',
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
                        hintText: "학교 이메일 입력",
                        textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w400),
                        verticalPadding: 15,
                      ),
                    ),
                    const SizedBox(width:12),
                    SmallButton(text: '인증하기', onPressed: () {}),
                  ],
                ),
              ],
            ),
          ),
        ));
  }
}
