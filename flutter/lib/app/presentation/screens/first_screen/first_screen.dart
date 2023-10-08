import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'first_screen_controller.dart';

class FirstScreen extends GetView<FirstScreenController> {
  const FirstScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: "아이디"),
              controller: controller.idCon,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "비밀번호"),
              controller: controller.pwdCon,
            ),
            const SizedBox(height: 20),
            Obx(()=>
              // Elevated Button은 OnPressed가 null이면 알아서 disable 상태에
              // 돌입한다
              ElevatedButton(
                onPressed: controller.canLogin?() {} :null,
                child: const Text("로그인"),
              ),
            ),
            TextButton(
              onPressed: controller.onSignUpButtonTap,
              child: const Text("회원가입"),
            )
          ],
        ),
      ),
    ));
  }
}

// TODO 여기 주목 - 하단의 주석처리된 친구를 복사 해서 get_pages.dart로 ㄱㄱ
// GetPage(
//   name: ,
//   page: () => const FirstScreen(),
//   binding: FirstScreenBinding(),
// )
