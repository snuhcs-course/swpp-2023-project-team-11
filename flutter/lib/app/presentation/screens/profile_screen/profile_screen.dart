import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';

// ignore: unused_import
import 'profile_screen_controller.dart';

class ProfileScreen extends GetView<ProfileScreenController> {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const NotiAppBar(
        title: Text(
          "프로필",
          style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xff2d3a45)),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 16, left: 24, right: 24),
        child: Column(
          children: [
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox.fromSize(
                    size: const Size.fromRadius(90),
                    child: Image.asset('assets/images/snek_profile_img_1.webp'),
                  ),
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(controller.userController.userName,
                        style: const TextStyle(
                            color: Color(0xff2d3a45),
                            fontWeight: FontWeight.w700,
                            fontSize: 24)),
                    const SizedBox(height: 10),
                    Wrap(
                      children: [
                        Container(
                          width: 120,
                          decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Text(controller.userController.userAboutMe,
                              style: const TextStyle(
                                  color: Color(0xff2d3a45),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 20)),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),

            MainButton(mainButtonType: MainButtonType.key, text: "로그아웃", onPressed: controller.onLogOutButtonTap),





          ],
        ),
      ),

    );
  }
}

// GetPage(
//   name: ,
//   page: () => const ProfileScreen(),
//   binding: ProfileScreenBinding(),
// )
