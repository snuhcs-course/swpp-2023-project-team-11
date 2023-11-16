import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/screens/chatting_rooms_screen/chatting_rooms_screen.dart';
import 'package:mobile_app/app/presentation/screens/friends_screen/friends_screen.dart';
import 'package:mobile_app/app/presentation/screens/main_screen/widgets/snekBottomNavigationBar.dart';
import 'package:mobile_app/app/presentation/screens/profile_screen/profile_screen.dart';

// ignore: unused_import
import 'main_indexed_screen_controller.dart';

class MainIndexedScreen extends GetView<MainIndexedScreenController> {
  const MainIndexedScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      extendBody: true,
      bottomNavigationBar: Obx(() => SnekBottomNavigationBar(
              currentIndex: controller.currentIndex.value,
              onTap: (index) {
          controller.currentIndex(index);
        },
              )
          //     BottomNavigationBar(
          //   onTap: (index) { Image.asset("assets/images/sneki_holding_here.png")
          //     controller.currentIndex(index);
          //   },
          //   currentIndex: controller.currentIndex.value,
          //   items: const [
          //     BottomNavigationBarItem(icon: Icon(Icons.abc), label: "0"),
          //     BottomNavigationBarItem(icon: Icon(Icons.abc), label: "1"),
          //     BottomNavigationBarItem(icon: Icon(Icons.abc), label: "2"),
          //   ],
          // ),
          ),
    );
  }
}
