import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: unused_import
import '../../../domain/models/user.dart';
import '../../widgets/app_bars.dart';
import 'friends_screen_controller.dart';

import 'package:flutter/cupertino.dart';

class FriendsScreen extends GetView<FriendsScreenController> {
  const FriendsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: NotiAppBar(
          title: Image.asset(
            'assets/images/SNEK_LOGO_small.png',
            fit: BoxFit.fill,
            height: 52,
          ),
        ),
        body: Obx(() => SmartRefresher(
            enablePullDown: true,
            header: WaterDropHeader(),
            controller: controller.refreshController,
            onRefresh: controller.onRefresh,
            child: _buildUserList())));
  }

  Widget _buildUserList() {
    if (controller.users.isEmpty) {
      return Center(child: Text("친구 목록을 로딩중이에요"));
    }
    return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return _buildUserContainer(controller.users[index]);
        },
        separatorBuilder: (context, index) {
          return SizedBox(height: 0);
        },
        itemCount: controller.users.length);
  }

  Widget _buildUserContainer(User user) {
    return Container(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox.fromSize(
                  child: Image.asset('assets/images/snek_profile_img_${controller.random.nextInt(5) + 1}.webp'),
                  size: Size.fromRadius(72),
                ),
              ),
              Positioned(
                left: 84,
                top: 96,
                child: ElevatedButton(
                  onPressed: () => {print("!")},
                  child: Icon(
                    Icons.favorite_outline,
                    color: Colors.black.withOpacity(0.4),
                  ),
                  style: ElevatedButton.styleFrom(
                      shape: CircleBorder(),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.white),
                ),
              ),
            ]),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name,
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff2d3a45))),
                        SizedBox(height: 4),
                        Text("${user.profile.aboutMe}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff2d3a45).withOpacity(0.8))),
                        SizedBox(height: 2),
                        Text("희망언어: ${user.getLanguages.join(", ")}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: Color(0xff2d3a45).withOpacity(0.8))),
                      ]),
                  SizedBox(height: 4),
                  Wrap(
                    children: [
                      _buildUserInfoBubble(user.profile.major),
                      SizedBox(
                        width: 8,
                      ),
                      _buildUserInfoBubble("${user.profile.admissionYear}"),
                      SizedBox(
                        width: 8,
                      ),
                      _buildUserInfoBubble("${user.profile.mbti}")
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoBubble(String info) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Text(info,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xff2d3a45).withOpacity(0.8),
              )),
        ),
        decoration: BoxDecoration(
            color: Color(0xffF8F1FB), borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Future<T> withLoadingOverlay<T>({
    required Future<T> Function() asyncFunction,
    Widget loadingWidget = const CupertinoActivityIndicator(),
  }) async {
    return await Get.showOverlay(
      asyncFunction: asyncFunction,
      opacity: 0,
      opacityColor: Colors.transparent,
      loadingWidget: Center(
        child: Obx(
          () => Material(
            color: Colors.black54,
            child: Container(
              child: Center(child: loadingWidget),
            ),
          ),
        ),
      ),
    );
  }
}

// GetPage(
//   name: ,
//   page: () => const FriendsScreen(),
//   binding: FriendsScreenBinding(),
// )
