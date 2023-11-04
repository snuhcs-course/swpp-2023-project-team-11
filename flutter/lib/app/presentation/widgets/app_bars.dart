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
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff2d3a45)),
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
      iconTheme: const IconThemeData(color: Colors.white),
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

class NotiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final Widget? additionalAction;

  const NotiAppBar({super.key, this.title, this.additionalAction});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      toolbarHeight: 64,
      title: (title != null) ? title : null,
      centerTitle: false,
      actions: [
        if(additionalAction != null) additionalAction!,
        ElevatedButton(
          onPressed: () => {print("!")},
          style: ElevatedButton.styleFrom(
              shape: const CircleBorder(),
              backgroundColor: const Color(0xfff8f1fb),
              foregroundColor: Colors.white),
          child: const Icon(
            Icons.notifications_none_rounded,
            color: Color(0xff9f75d1),
            size: 30,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize =>const  Size.fromHeight(64);
}
