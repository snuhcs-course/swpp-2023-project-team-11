import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mobile_app/core/constants/system_strings.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'package:mobile_app/core/utils/translation.dart';
import 'package:mobile_app/main.dart';

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
  final Widget? additionalAction;

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
      actions: [
        if (additionalAction != null) additionalAction!,
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);

  const ChattingRoomAppBar({required this.title, super.key, this.additionalAction});
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
        if (additionalAction != null) additionalAction!,
        // ElevatedButton(
        //   onPressed: () => {print("!")},
        //   style: ElevatedButton.styleFrom(
        //       shape: const CircleBorder(),
        //       backgroundColor: const Color(0xfff8f1fb),
        //       foregroundColor: Colors.white),
        //   child: const Icon(
        //     Icons.notifications_none_rounded,
        //     color: Color(0xff9f75d1),
        //     size: 30,
        //   ),
        // ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(64);
}

class FriendDetailAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ImageProvider profileImage;
  final String userName;
  final String userEmail;
  final bool isMyProfile;
  final void Function()? actionFunction;

  const FriendDetailAppBar({
    super.key,
    required this.profileImage,
    required this.userName,
    required this.userEmail,
    this.isMyProfile = false,
    this.actionFunction,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: MyColor.purple,
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      clipBehavior: Clip.none,
      title: isMyProfile
          ? Text("내 프로필".tr,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Colors.white))
          : null,
      centerTitle: false,
      actions: isMyProfile
          ? [
              PopupMenuButton(
                  icon: const Icon(Icons.settings),
                  itemBuilder: (context) {
                    return [
                      // PopupMenuItem<int>(
                      //     value: 0,
                      //     child: Text("프로필 편집".tr,
                      //         style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                      PopupMenuItem<int>(
                          value: 1,
                          child: Text("언어 변경".tr,
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500))),
                    ];
                  },
                  onSelected: (value) {
                    if (value == 0) {
                      print("My account menu is selected.");
                      actionFunction!();
                    } else if (value ==1) {
                      MyLanguageUtil.toggle();
                      sp.setString(language_setting, MyLanguageUtil.getLocale.toString());
                      print(MyLanguageUtil.getLocale.toString());
                    }

                  })
            ]
          : null,
      bottom: PreferredSize(
        preferredSize: preferredSize,
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 60,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                color: Colors.white,
              ),
            ),
            Positioned(
              top: -40,
              left: 20,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: profileImage,
                  ),
                  const SizedBox(width: 12),
                  SizedBox(
                    height: 80,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            userName,
                            style: const TextStyle(
                                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            userEmail,
                            style: const TextStyle(
                              fontSize: 13,
                              color: MyColor.purple,
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(162);
}
