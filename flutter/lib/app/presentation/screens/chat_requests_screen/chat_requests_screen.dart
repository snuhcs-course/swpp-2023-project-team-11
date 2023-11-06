import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/presentation/widgets/profile_pic_provider.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'dart:math' as math;

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
      appBar: const NotiAppBar(
        title: Text(
          "채팅 요청",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xff2d3a45)),
        ),
      ),
      body: controller.chattingRoomController.obx(
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
          const Text(
            "새로운 채팅 요청이 지금은 없어요!",
            style: TextStyle(color: Color(0xff9f75d1), fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(
            height: 36,
          ),
          SmallButton(onPressed: controller.onBrowseFriendsButtonTap, text: "친구 둘러보기")
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
              radius: 30,
              backgroundImage: ProfilePic().call(chatroom.initiator.email)
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(chatroom.initiator.name,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xff2d3a45))),
                    const SizedBox(width: 8),
                    Text(
                        "${chatroom.createdAt.toLocal().year}년 ${chatroom.createdAt.toLocal().month}월 ${chatroom.createdAt.toLocal().day}일",
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xffff9162)))
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  "상대(아직 친구가 아닌 사람)가 보낸 메세지",
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xff2d3a45).withOpacity(0.8)),
                )
              ],
            ),
          ),
          const SizedBox(width: 12),
          Transform.rotate(
            angle: -math.pi / 2,
            child: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(value: 0, child: Text("삭제")),
                  const PopupMenuItem<int>(value: 1, child: Text("수락")),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  print("삭제");
                } else if (value == 1) {
                  controller.onAcceptButtonTap(chatroom);
                }
              },
              color: const Color(0xff2d3a45).withOpacity(0.4),
            ),
          )
        ],
      ),
    );
  }
}

// GetPage(
//   name: ,
//   page: () => const ChatRequestsScreen(),
//   binding: ChatRequestsScreenBinding(),
// )
