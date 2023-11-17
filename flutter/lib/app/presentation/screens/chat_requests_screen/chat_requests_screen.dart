import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/profile_pic_provider.dart';
import 'package:mobile_app/core/themes/color_theme.dart';

// ignore: unused_import
import '../../../domain/models/chatting_room.dart';
import '../../widgets/app_bars.dart';
import '../../widgets/buttons.dart';
import 'chat_requests_screen_controller.dart';

class ChatRequestsScreen extends GetView<ChatRequestsScreenController> {
  const ChatRequestsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: NotiAppBar(
        title: Text(
          "채팅 요청".tr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xff2d3a45)),
        ),
      ),
      body: controller.chattingRoomListController.obx(
        (state) {
          if (state!.roomForRequested.isEmpty) {
            return _buildEmptyChattingRoomResponse();
          } else {
            return _buildChatroomList(state.roomForRequested);
          }
        },
          onLoading: const Center(child: CircularProgressIndicator(color: MyColor.orange_1,),)
      ),
    );
  }

  Widget _buildEmptyChattingRoomResponse() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "새로운 채팅 요청이 지금은 없어요!".tr,
            style: TextStyle(color: MyColor.purple, fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(
            height: 36,
          ),
          SmallButton(onPressed: controller.onBrowseFriendsButtonTap, text: "친구 둘러보기".tr)
        ],
      ),
    );
  }

  Widget _buildChatroomList(List<ChattingRoom> chattingRooms) {
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _buildChatroomContainer(chattingRooms[index], context);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 0);
        },
        itemCount: chattingRooms.length);
  }

  Widget _buildChatroomContainer(ChattingRoom chatroom, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: GestureDetector(
        onTap: () {
          controller.onProfileTap(chatroom.initiator, chatroom);
        },
        behavior: HitTestBehavior.opaque,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 27,
                backgroundImage: ProfilePic.call(chatroom.initiator.email)
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(chatroom.initiator.name,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xff2d3a45))),
                      const SizedBox(width: 8),
                      Text(
                          "${chatroom.createdAt.toLocal().year} / ${chatroom.createdAt.toLocal().month} / ${chatroom.createdAt.toLocal().day}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xffff9162)))
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    chatroom.initiator.name+"님의 채팅 요청이 왔어요!".tr,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff2d3a45).withOpacity(0.8)),
                  )
                ],
              ),
            ),
            const SizedBox(width: 12),
              PopupMenuButton(
                icon: Icon(Icons.more_vert, color: const Color(0xff2d3a45).withOpacity(0.4),),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(value: 0, child: Text("삭제".tr)),
                    PopupMenuItem<int>(value: 1, child: Text("수락".tr)),
                  ];
                },
                onSelected: (value) {
                  if (value == 0) {
                  } else if (value == 1) {
                    controller.onAcceptButtonTap(chatroom);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}

// GetPage(
//   name: ,
//   page: () => const ChatRequestsScreen(),
//   binding: ChatRequestsScreenBinding(),
// )
