import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;

  const SimpleAppBar({super.key, this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      toolbarHeight: 64,
      title: (title != null)
          ? Text(
              title!,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xff2d3a45)),
            )
          : null,
      leading: BackButton(
        color: const Color(0xff2D3A45).withOpacity(0.4),
        onPressed: Get.back,
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class ChattingRoomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xff9F75D1),
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);

  const ChattingRoomAppBar({
    required this.title,
    super.key,
  });
}
