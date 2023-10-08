import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'sign_up_screen_controller.dart';

class SignUpScreen extends GetView<SignUpScreenController> {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("회원가입"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              controller: controller.idCon,
              decoration: const InputDecoration(labelText: "아이디"),
            ),
            TextFormField(
              controller: controller.nameCon,
              decoration: const InputDecoration(labelText: "이름"),
            ),
            TextFormField(
              controller: controller.pwdCon,
              decoration: const InputDecoration(labelText: "비밀번호"),
            ),
            TextFormField(
              controller: controller.pwdCheckCon,
              decoration: const InputDecoration(labelText: "비밀번호 확인"),
            ),
            const SizedBox(height: 20),
            GetBuilder<SignUpScreenController>(
              builder: (controller) {
                return ElevatedButton(
                  onPressed: controller.allowSubmit?controller.onSubmit : null,
                  child: const Text("제출"),
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}
