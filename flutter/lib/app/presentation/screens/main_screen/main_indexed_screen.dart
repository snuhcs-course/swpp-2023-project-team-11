import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/screens/chatting_rooms_screen/chatting_rooms_screen.dart';
import 'package:mobile_app/app/presentation/screens/friends_screen/friends_screen.dart';
import 'package:mobile_app/app/presentation/screens/profile_screen/profile_screen.dart';
import 'package:mobile_app/app/presentation/screens/profile_survey_screen/profile_survey_screen.dart';
import 'package:mobile_app/app/presentation/screens/profile_survey_screen/profile_survey_screen_binding.dart';

// ignore: unused_import
import 'main_indexed_screen_controller.dart';

class MainIndexedScreen extends GetView<MainIndexedScreenController> {
  const MainIndexedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(
            () => const ProfileSurveyScreen(),
            binding: ProfileSurveyScreenBinding(),
          );
        },
      ),
      body: Obx(
        () => IndexedStack(
          index: controller.currentIndex.value,
          children: const [
            FriendsScreen(),
            ChattingRoomsScreen(),
            ProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          onTap: (index) {
            controller.currentIndex(index);
          },
          currentIndex: controller.currentIndex.value,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.abc),
              label: "0",
            ),
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: "1"),
            BottomNavigationBarItem(icon: Icon(Icons.abc), label: "2"),
          ],
        ),
      ),
    );
  }
}
