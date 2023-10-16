import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'chatting_rooms_screen_controller.dart';

class ChattingRoomsScreen extends GetView<ChattingRoomsScreenController> {
  const ChattingRoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('chatting_rooms'))
    );
  }
}

// GetPage(
//   name: ,
//   page: () => const ChattingRoomsScreen(),
//   binding: ChattingRoomsScreenBinding(),
// )
