import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'email_screen_controller.dart';

class EmailScreen extends GetView<EmailScreenController> {
  const EmailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text('email')
    );
  }
}


