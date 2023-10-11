import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'splash_screen_controller.dart';

class SplashScreen extends GetView<SplashScreenController> {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('splash')
    );
  }
}

// GetPage(
//   name: ,
//   page: () => const SplashScreen(),
//   binding: SplashScreenBinding(),
// )
