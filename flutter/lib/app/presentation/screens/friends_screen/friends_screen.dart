import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/profile_pic_provider.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
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
      body: controller.obx(
              (state) {
            if (state!.isEmpty) {
              return const Center(child: Text("현재 검색되는 유저가 존재하지 않습니다"));
            }
            return SmartRefresher(
                enablePullDown: true,
                header: const WaterDropHeader(),
                controller: controller.refreshController,
                onRefresh: controller.onRefresh,
                child: _buildUserList(state));
          },
          onLoading: const Center(
            child: CircularProgressIndicator(color: MyColor.orange_1,),)
      ),
    );
  }

  Widget _buildUserList(List<User> users) {
    return ListView.separated(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemBuilder: (context, index) {
          return _buildUserContainer(users[index]);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 0);
        },
        itemCount: users.length);
  }

  Widget _buildUserContainer(User user) {
    return GestureDetector(
      onTap: () {
        controller.onUserContainerTap(user);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        child: Row(
          children: [
            Stack(children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: SizedBox.fromSize(
                    size: const Size.fromRadius(72),
                    child: Image(image: ProfilePic().call(user.email))
                  // ProfilePic().call(user.email)
                  // Image.asset('assets/images/snek_profile_img_${controller.random.nextInt(5) + 1}.webp'),
                ),
              ),
              Obx(() {
                return Positioned(
                  left: 84,
                  top: 96,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.heartedUser.value.contains(user)) {
                        controller.heartedUser.value.remove(user);
                        controller.heartedUser.refresh();
                      }
                      else {
                        controller.heartedUser.value.add(user);
                        controller.heartedUser.refresh();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.white),
                    child: Icon(
                      controller.heartedUser.value.contains(user)
                          ? Icons.favorite
                          : Icons.favorite_outline,
                      color: Colors.black.withOpacity(0.4),
                    ),
                  ),
                );
              }),
            ]),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(user.name,
                        style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Color(0xff2d3a45))),
                    const SizedBox(height: 4),
                    Text(user.profile.aboutMe,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff2d3a45).withOpacity(0.8))),
                    const SizedBox(height: 2),
                    Text("희망언어: ${user.getLanguages.join(", ")}",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff2d3a45).withOpacity(0.8))),
                  ]),
                  const SizedBox(height: 4),
                  Wrap(
                    children: [
                      _buildUserInfoBubble(user.profile.major),
                      const SizedBox(
                        width: 8,
                      ),
                      _buildUserInfoBubble("${user.profile.admissionYear}"),
                      const SizedBox(
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
        decoration:
        BoxDecoration(color: const Color(0xffF8F1FB),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
          child: Text(info,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: const Color(0xff2d3a45).withOpacity(0.8),
              )),
        ),
      ),
    );
  }

// Future<T> withLoadingOverlay<T>({
//   required Future<T> Function() asyncFunction,
//   Widget loadingWidget = const CupertinoActivityIndicator(),
// }) async {
//   return await Get.showOverlay(
//     asyncFunction: asyncFunction,
//     opacity: 0,
//     opacityColor: Colors.transparent,
//     loadingWidget: Center(
//       child: Obx(
//         () => Material(
//           color: Colors.black54,
//           child: Container(
//             child: Center(child: loadingWidget),
//           ),
//         ),
//       ),
//     ),
//   );
// }
}

// GetPage(
//   name: ,
//   page: () => const FriendsScreen(),
//   binding: FriendsScreenBinding(),
// )
