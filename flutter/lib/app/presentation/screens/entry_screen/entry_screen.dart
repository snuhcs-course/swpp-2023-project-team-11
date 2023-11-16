import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';

// ignore: unused_import
import 'entry_screen_controller.dart';

class EntryScreen extends GetView<EntryScreenController> {
  const EntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff2e2f3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 200),
          _buildLogoContainer(),
        ],
      ),
      bottomNavigationBar: _buildActionsContainer(context),
      extendBody: true,
    );
  }

  Widget _buildLogoContainer() {
    return SizedBox(
      child: Column(
        children: [
          Image.asset(
            'assets/images/SNEK_LOGO.png',
            width: 140,
            height: 112,
          ),
          const SizedBox(height: 8),
          const Text(
            "간식보다 재밌는 언어교환",
            style: TextStyle(fontSize: 16, color: Color(0xff9f75d1)),
          ),
          const Text(
            "SNEK",
            style: TextStyle(
              fontSize: 30,
              color: Color(0xffff733d),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24).copyWith(
        bottom: MediaQuery.of(context).padding.bottom / 2 + 24,
      ),
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
        ),
        color: Colors.white,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          MainButton(
            mainButtonType: MainButtonType.light,
            text: '로그인',
            onPressed: controller.onSignInButtonTap,
          ),
          const SizedBox(height: 16),
          MainButton(
            mainButtonType: MainButtonType.key,
            text: '회원가입',
            onPressed: controller.onSignUpButtonTap,
          ),
        ],
      ),
    );
  }

  Widget _buildButton({
    required String text,
    required Color color,
    required void Function() onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.maxFinite,
        height: 52,
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
