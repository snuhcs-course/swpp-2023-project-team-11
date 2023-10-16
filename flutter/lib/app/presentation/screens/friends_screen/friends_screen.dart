import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'friends_screen_controller.dart';

class FriendsScreen extends GetView<FriendsScreenController> {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('friends'))
    );
  }
}

// GetPage(
//   name: ,
//   page: () => const FriendsScreen(),
//   binding: FriendsScreenBinding(),
// )
