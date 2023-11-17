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
        title: Text(
          " 채팅".tr,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: Color(0xff2d3a45)),
        ),
        additionalAction: Obx(() {
          return _buildNewRequestButton();
        }),
      ),
      body: controller.chattingRoomListController.obx((state) {
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
          onLoading: const Center(
            child: CircularProgressIndicator(
              color: MyColor.orange_1,
            ),
          )),
    );
  }

  Widget _buildNewRequestButton() {
    return Stack(children: [
      GestureDetector(
        onTap: () {
          controller.onNewChatRequestTap();
        },
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text(
            "새로운 채팅 요청".tr,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: MyColor.purple),
          ),
        ),
      ),
      if (controller.newChatRequestExists.value)
        const Positioned(
          // draw a red marble
          top: 12,
          right: 8,
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
          Text(
            "아직 아무도 친구가 되지 않았어요!".tr,
            style: TextStyle(color: MyColor.purple, fontWeight: FontWeight.w600, fontSize: 18),
          ),
          const SizedBox(
            height: 10,
          ),
          Text("친구 신청을 보내고".tr,
              style: TextStyle(
                  color: const Color(0xff2d3a45).withOpacity(0.64),
                  fontWeight: FontWeight.w400,
                  fontSize: 14)),
          Text("새로운 친구를 만들어보세요".tr,
              style: TextStyle(
                  color: const Color(0xff2d3a45).withOpacity(0.64),
                  fontWeight: FontWeight.w400,
                  fontSize: 14)),
          const SizedBox(
            height: 36,
          ),
          SmallButton(onPressed: () => {}, text: "친구 둘러보기".tr)
        ],
      ),
    );
  }

  Widget _buildChatroomList(List<ChattingRoom> chattingRooms) {
    return ListView.separated(
        padding: const EdgeInsets.only(bottom: 100),
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
    if (chatroom.isTerminated) {
      return const SizedBox.shrink();
    } else {
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
                  radius: 27,
                  backgroundImage: ProfilePic.call(
                      (chatroom.responder.name == controller.userController.userName)
                          ? chatroom.initiator.email
                          : chatroom.responder.email)),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                              (chatroom.responder.name == controller.userController.userName)
                                  ? chatroom.initiator.name
                                  : chatroom.responder.name,
                              style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xff2d3a45))),
                          const SizedBox(width: 8),
                          (chatroom.isApproved && !chatroom.isTerminated)
                              ? Text(
                                  controller.checkSp(chatroom.id)
                                      ? "${controller.timeToDisplay(chatroom)}"
                                      : "${chatroom.createdAt.toLocal().year} / ${chatroom.createdAt.toLocal().month} / ${chatroom.createdAt.toLocal().day}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: MyColor.purple))
                              : Text(
                                  "${chatroom.createdAt.toLocal().year} / ${chatroom.createdAt.toLocal().month} / ${chatroom.createdAt.toLocal().day}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: MyColor.purple))
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        chatroom.isTerminated
                            ? "종료된 채팅방입니다".tr
                            : (chatroom.isApproved
                                ? (controller.checkSp(chatroom.id)
                                    ? (controller
                                            .latestChatMessage(chatroom.id)
                                            .characters
                                            .take(25)
                                            .toString() +
                                        ((controller
                                                    .latestChatMessage(chatroom.id)
                                                    .characters
                                                    .length >
                                                30)
                                            ? "..."
                                            : ""))
                                    : "채팅을 시작해봐요!".tr)
                                : "아직 상대가 수락하지 않았습니다".tr),
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xff2d3a45).withOpacity(0.8)),
                      ),
                      // ElevatedButton(onPressed: (){
                      //   print("${controller.spC.getString(chatroom.id.toString())} is what i found from sp - decoding");
                      // }, child: Icon(Icons.favorite))
                    ],
                  ),
                ),
              ),
              // const SizedBox(width: 12),
              PopupMenuButton(
                icon: Icon(
                  Icons.more_vert,
                  color: const Color(0xff2d3a45).withOpacity(0.4),
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem<int>(
                        value: 1,
                        child: Text(
                          "채팅방 나가기".tr,
                          style: TextStyle(color: MyColor.orange_1),
                        )),
                  ];
                },
                onSelected: (value) {
                  if (value == 1) {
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
}

// GetPage(
//   name: ,
//   page: () => const ChattingRoomsScreen(),
//   binding: ChattingRoomsScreenBinding(),
// )
