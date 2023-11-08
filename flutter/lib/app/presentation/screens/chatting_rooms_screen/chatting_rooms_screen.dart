import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/presentation/widgets/app_bars.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/app/presentation/widgets/profile_pic_provider.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

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
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xff2d3a45)),
        ),
        additionalAction: Obx(() {
          return _buildNewRequestButton();
        }),
      ),
      body: controller.chattingRoomListController.obx(
        (state) {
          if (state!.roomForMain.isEmpty) {
            return _buildEmptyChatRoomResponse();
          } else {
            return SmartRefresher(
              enablePullDown: true,
                header: const WaterDropHeader(),
                controller: controller.refreshController,
                onRefresh: controller.onRefresh,
                child: _buildChatroomList(state.roomForMain));
          }
        },
        onLoading: const Center(child: CircularProgressIndicator(color: MyColor.orange_1,),)
      ),
    );
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
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Color(0xff9f75d1)),
          ),
        ),
      ),
      if (controller.newChatRequestExists.value != null && controller.newChatRequestExists.value!)
        const Positioned(
          // draw a red marble
          top: 4,
          right: 0,
          child: Icon(Icons.brightness_1, size: 14, color: Color(0xffff733d)),
        )
    ]);
  }

  Widget _buildEmptyChatRoomResponse() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            "아직 아무도 친구가 되지 않았어요!",
            style: TextStyle(color: Color(0xff9f75d1), fontWeight: FontWeight.w600, fontSize: 18),
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
    return GestureDetector(
      onTap: () {
        controller.onChattingRoomTap(chatroom);
      },
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: ProfilePic().call((chatroom.responder.name == controller.userController.userName)? chatroom.initiator.email:chatroom.responder.email)
            ),
            const SizedBox(width: 16),
            Expanded(
              child: SizedBox(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text((chatroom.responder.name == controller.userController.userName)? chatroom.initiator.name:chatroom.responder.name,
                            style: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w700, color: Color(0xff2d3a45))),
                        const SizedBox(width: 8),
                        Text(
                            "${chatroom.createdAt.toLocal().year}년 ${chatroom.createdAt.toLocal().month}월 ${chatroom.createdAt.toLocal().day}일",
                            style: const TextStyle(
                                fontSize: 12, fontWeight: FontWeight.w400, color: Color(0xff9f75d1)))
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      chatroom.isTerminated?"종료된 채팅방입니다": chatroom.isApproved?"채팅룸의 가장 최근 대화":"아직 상대가 수락하지 않았습니다",
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
            PopupMenuButton(
              icon: Icon(Icons.more_vert, color: Color(0xff2d3a45).withOpacity(0.4),),
              itemBuilder: (context) {
                return [
                  const PopupMenuItem<int>(value: 0, child: Text("알림 음소거")),
                  const PopupMenuItem<int>(value: 1, child: Text("채팅방 나가기", style: TextStyle(color: MyColor.orange_1),)),
                ];
              },
              onSelected: (value) {
                if (value == 0) {
                  print("알림 음소거");
                } else if (value == 1) {
                  controller.onChattingRoomLeaveTap(chatroom);
                }
              },
              // color: const Color(0xff2d3a45).withOpacity(0.4),
            )
          ],
        ),
      ),
    );
  }
}

// GetPage(
//   name: ,
//   page: () => const ChattingRoomsScreen(),
//   binding: ChattingRoomsScreenBinding(),
// )
