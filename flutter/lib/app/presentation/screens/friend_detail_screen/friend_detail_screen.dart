

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/app/presentation/widgets/profile_detail_column.dart';
import 'package:mobile_app/app/presentation/widgets/profile_pic_provider.dart';

// ignore: unused_import
import 'friend_detail_screen_controller.dart';

class FriendDetailScreen extends GetView<FriendDetailScreenController> {
  const FriendDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FriendDetailAppBar(
        profileImage: ProfilePic.call(controller.user.email),
        // AssetImage(
        //   'assets/images/snek_profile_img_${Random().nextInt(5) + 1}.webp',
        // ),
        userName: "${controller.user.name}",
        userEmail: "${controller.user.email}",
      ),
      // TODO 화면 그리기
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: SingleChildScrollView(
          child: ProfileDetailColumn(user: controller.user),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(20)
            .copyWith(bottom: 20 + MediaQuery.of(context).padding.bottom / 2),
        child: MainButton(
          mainButtonType: MainButtonType.key,
          onPressed: controller.onRequestButtonTap,
          text: "채팅 신청",
        ),
      ),
    );
  }
}
