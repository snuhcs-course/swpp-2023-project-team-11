import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/app/presentation/widgets/profile_pic_provider.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// ignore: unused_import
import '../../../domain/models/user.dart';
import '../../widgets/app_bars.dart';
import 'friends_screen_controller.dart';

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
      body: controller.obx((state) {
        if (state!.isEmpty) {
          return _buildEmptyFriendsContainer();
        }
        return SmartRefresher(
          enablePullDown: true,
          header: const WaterDropHeader(),
          controller: controller.refreshController,
          onRefresh: controller.onRefresh,
          child: _buildUserList(state),
        );
      },
          onLoading: const Center(
            child: CircularProgressIndicator(
              color: MyColor.orange_1,
            ),
          )),
    );
  }

  Widget _buildEmptyFriendsContainer() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "현재 검색되는 유저가 존재하지 않습니다".tr,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: MyColor.purple,
                fontWeight: FontWeight.w600,
                fontSize: 18),
          ),
          const SizedBox(
            height: 26,
          ),
          SmallButton(
            onPressed: () {
              controller.onRefresh();
            },
            text: "새로고침".tr,
          )
        ],
      ),
    );
  }

  Widget _buildUserList(List<User> users) {
    return ListView.separated(
        padding: const EdgeInsets.only(bottom: 100),
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
                    size: const Size.fromRadius(60),
                    child: Image(image: ProfilePic.call(user.email))
                    // ProfilePic().call(user.email)
                    // Image.asset('assets/images/snek_profile_img_${controller.random.nextInt(5) + 1}.webp'),
                    ),
              ),
              Obx(() {
                return Positioned(
                  left: 60,
                  top: 72,
                  child: ElevatedButton(
                    onPressed: () {
                      if (controller.heartedUser.value.contains(user)) {
                        controller.heartedUser.value.remove(user);
                        controller.heartedUser.refresh();
                      } else {
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
                      color: controller.heartedUser.value.contains(user)
                          ? Colors.redAccent.withOpacity(0.8)
                          : Colors.black.withOpacity(0.4),
                    ),
                  ),
                );
              }),
            ]),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user.name,
                            style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: Color(0xff2d3a45))),
                        const SizedBox(height: 4),
                        Text(
                            (user.profile.aboutMe.length > 20)
                                ? "${user.profile.aboutMe.substring(0, 20)}..."
                                : user.profile.aboutMe,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color:
                                    const Color(0xff2d3a45).withOpacity(0.8))),
                        const SizedBox(height: 2),
                        Text(
                            "${user.getNationCode != 82 ? "사용 언어".tr : "희망 언어".tr}: ${user.getLanguages.take(4).map((languageName) => languageName.name.capitalize).join(", ")}${(user.getLanguages.length > 4) ? '...' : ''}",
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color:
                                    const Color(0xff2d3a45).withOpacity(0.8))),
                      ]),
                  const SizedBox(height: 4),
                  Wrap(
                    children: [
                      _buildUserInfoBubble(user.profile.major),
                      const SizedBox(
                        width: 6,
                      ),
                      _buildUserInfoBubble("${user.profile.admissionYear}"),
                      const SizedBox(
                        width: 6,
                      ),
                      if (user.profile.mbti != Mbti.UNKNOWN)
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
        decoration: BoxDecoration(
            color: const Color(0xffF8F1FB),
            borderRadius: BorderRadius.circular(10)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
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
