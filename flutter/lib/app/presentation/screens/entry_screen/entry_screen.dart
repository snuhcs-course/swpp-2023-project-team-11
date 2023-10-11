import 'package:get/get.dart';
import 'package:flutter/material.dart';

// ignore: unused_import
import 'entry_screen_controller.dart';

class EntryScreen extends GetView<EntryScreenController> {
  const EntryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xfff2e2f3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_buildLogoContainer()],
      ),
      bottomNavigationBar: _buildActionsContainer(context),
    );
  }

  Widget _buildLogoContainer() {
    return Container(
      child: Column(
        children: [
          Container(
            width: 140,
            height: 112,
            color: Colors.orange,
          ),
          const SizedBox(height: 8),
          Text(
            "일이삼사오육칠팔구십이삼사",
            style: TextStyle(fontSize: 16, color: const Color(0xff9f75d1)),
          ),
          Text(
            "SNEK",
            style: TextStyle(fontSize: 30, color: const Color(0xffff733d)),
          ),
        ],
      ),
    );
  }

  Widget _buildActionsContainer(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24).copyWith(
        bottom: MediaQuery.of(context).padding.bottom / 2 + 12,
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
          _buildButton(
            text: '로그인',
            color: Color(0xfff8f1f8),
            onTap: () {},
          ),
          const SizedBox(height: 16),
          _buildButton(
            text: '회원가입',
            color: Color(0xffff733d),
            onTap: () {},
          ),
          const SizedBox(height: 24),
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
        padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        alignment: Alignment.center,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
