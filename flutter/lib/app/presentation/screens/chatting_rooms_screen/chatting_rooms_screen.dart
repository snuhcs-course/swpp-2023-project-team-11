import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'dart:math' as math;

// ignore: unused_import
import 'chatting_rooms_screen_controller.dart';

class ChattingRoomsScreen extends GetView<ChattingRoomsScreenController> {
  const ChattingRoomsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: NotiAppBar(
          title: const Text(
            " 채팅",
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xff2d3a45)),
          ),
          additionalAction: Obx(() {
            return _buildNewRequestButton();
          }),
        ),
        body: Obx(() => _buildChatroomList()));
  }

  Widget _buildNewRequestButton() {
    return Stack(children: [
            GestureDetector(
              onTap: () {
                controller.onNewChatRequestTap();
              },
              child: const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "새로운 채팅 요청",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff9f75d1)),
                ),
              ),
            ),
            if (controller.newChatRequestExists.value == true) const Positioned(  // draw a red marble
              top: 4,
              right: 0,
              child: Icon(Icons.brightness_1, size: 14,
                  color: Color(0xffff733d)),
            )
          ]);
  }

  Widget _buildChatroomList() {
    if (controller.chatrooms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Text(
              "아직 아무도 친구가 되지 않았어요!",
              style: TextStyle(
                  color: Color(0xff9f75d1),
                  fontWeight: FontWeight.w600,
                  fontSize: 18),
            ),
            const SizedBox(
              height: 10,
            ),
            Text("친구 신청을 보내고",
                style: TextStyle(
                    color: const Color(0xff2d3a45).withOpacity(0.64),
                    fontWeight: FontWeight.w400,
                    fontSize: 14)),
            Text("새로운 친구를 만들어보세요",
                style: TextStyle(
                    color: const Color(0xff2d3a45).withOpacity(0.64),
                    fontWeight: FontWeight.w400,
                    fontSize: 14)),
            const SizedBox(
              height: 36,
            ),
            SmallButton(onPressed: () => {}, text: "친구 둘러보기")
          ],
        ),
      );
    }
    return ListView.separated(
        shrinkWrap: true,
        itemBuilder: (context, index) {
          return _buildChatroomContainer(controller.chatrooms[index], context);
        },
        separatorBuilder: (context, index) {
          return const SizedBox(height: 0);
        },
        itemCount: controller.chatrooms.length);
  }

  Widget _buildChatroomContainer(ChattingRoom chatroom, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey.withOpacity(0.4),
                border: Border.all(width: 1.5, color: const Color(0xffff9162))),
            width: 54,
            height: 54,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text("상대 이름",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: Color(0xff2d3a45))),
                      const SizedBox(width: 8),
                      Text(
                          "${chatroom.createdAt
                              .toLocal()
                              .year}년 ${chatroom.createdAt
                              .toLocal()
                              .month}월 ${chatroom.createdAt
                              .toLocal()
                              .day}일",
                          style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xff9f75d1)))
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "채팅룸의 가장 최근 대화",
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xff2d3a45).withOpacity(0.8)),
                  )
                ],
              ),
            ),
          ),
          // const SizedBox(width: 12),
          Transform.rotate(
            angle: -math.pi / 2,
            child: PopupMenuButton(
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(value: 0, child: Text("퇴장")),
                  const PopupMenuItem<int>(value: 1, child: Text("읽음 처리")),
                  const PopupMenuItem<int>(value: 2, child: Text("차단"))
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  print("퇴장");
                } else if (value == 1) {
                  print("읽음으로 처리");
                } else if (value == 2) {
                  print("차단");
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
//   page: () => const ChattingRoomsScreen(),
//   binding: ChattingRoomsScreenBinding(),
// )
