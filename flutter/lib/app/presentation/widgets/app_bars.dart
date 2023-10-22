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
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xff2d3a45)),
            )
          : null,
      leading: BackButton(
        color: Color(0xff2D3A45).withOpacity(0.4),
        onPressed: Get.back,
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64);
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
          child: Icon(
            Icons.notifications_none_rounded,
            color: Color(0xff9f75d1),
            size: 30,
          ),
          style: ElevatedButton.styleFrom(
              shape: CircleBorder(),
              backgroundColor: Color(0xfff8f1fb),
              foregroundColor: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(64);
}
