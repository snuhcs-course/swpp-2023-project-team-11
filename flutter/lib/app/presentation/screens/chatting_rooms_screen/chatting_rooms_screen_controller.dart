import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chat.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_list_controller.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/app/presentation/widgets/basic_dialog.dart';
import 'package:mobile_app/app/presentation/widgets/buttons.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'package:mobile_app/core/utils/loading_util.dart';
import 'package:mobile_app/core/utils/string_parser_util.dart';
import 'package:mobile_app/routes/named_routes.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile_app/main.dart';

class ChattingRoomsScreenController extends GetxController{

  final newChatRequestExists = false.obs; // 새로운 채팅 요청 여부에 따라 업데이트 돼어야함
  // bool get newChatRequestExists => (chattingRoomController.state == null)? false : (chattingRoomController.state!.roomForRequested.isNotEmpty);

  final ChattingRoomListController chattingRoomListController = Get.find<ChattingRoomListController>();
  final UserController userController = Get.find<UserController>();
  RefreshController refreshController = RefreshController(initialRefresh: false);
  final SharedPreferences spC = sp;

  bool checkSp(int chatRoomId){
    return spC.containsKey(chatRoomId.toString());
  }
  
  String latestChatMessage(int chatRoomId){
    Chat chat = Chat.fromJson(json.decode(spC.getString(chatRoomId.toString())!));
    return StringParserUtil.buildRoadmapText(chat.message);
  }

  DateTime timeOfLatestChatMessage(ChattingRoom chattingRoom){
    Chat chat = Chat.fromJson(json.decode(spC.getString(chattingRoom.id.toString())!));
    return chat.sentAt;
  }

  String timeToDisplay(ChattingRoom chattingRoom){
    DateTime timeOfChat = timeOfLatestChatMessage(chattingRoom).toLocal();
    Duration difference = DateTime.timestamp().difference(timeOfChat.add(timeOfChat.timeZoneOffset)); // 여기 시간 계산이 왜 이상한지를 모르겠네요ㅠ

    if(difference.compareTo(const Duration(minutes: 1)) < 0){
      return "방금 전".tr;
    }else if(difference.compareTo(const Duration(hours: 1)) < 0){
      return "${difference.inMinutes} "+"분 전".tr;
    }else if (difference.compareTo(const Duration(days: 1)) < 0){
      return "${difference.inHours} "+"시간 전".tr;
    }else{
      return "${timeOfChat.month} / ${timeOfChat.day}";
    }
  }

  void onNewChatRequestTap() {
    Get.toNamed(Routes.Maker(nextRoute: Routes.CHAT_REQUESTS));
  }

  void onRefresh() async{
    await chattingRoomListController.reloadRooms();
    newChatRequestExists((chattingRoomListController.numRequestedRooms != 0));
    // if failed, use refreshFailed()
    try {
      refreshController.refreshCompleted();
    } catch(e) {
      print("do nothing");
    }

  }

  void onChattingRoomTap(ChattingRoom chattingRoom) {
    if (chattingRoom.isApproved && !chattingRoom.isTerminated) {
      Get.toNamed(Routes.Maker(nextRoute: Routes.ROOM), arguments: chattingRoom);
    } else if(!chattingRoom.isApproved){
      Fluttertoast.showToast(
          msg: "수락되지 않은 채팅방입니다".tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: MyColor.orange_1,
          textColor: Colors.white,
          fontSize: 15.0
      );
    } else{
      Fluttertoast.showToast(
          msg: "더 이상 사용하지 않는 채팅방입니다".tr,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: MyColor.orange_1,
          textColor: Colors.white,
          fontSize: 15.0
      );
    }
  }

  void onChattingRoomLeaveTap(ChattingRoom chattingRoom) async {
    bool quitable = true;
    if(chattingRoom.isApproved){
      await Get.dialog(
          BasicDialog(
            title: '정말로 진행중인 채팅에서 나갈건가요?'.tr,
            contentWidget: const SizedBox.shrink(),
            mainLogicButton: MainButton(
              mainButtonType: MainButtonType.key,
              text: "네".tr,
              onPressed: (){quitable = true;Get.back();},
            ),
            leftSubButton: MainButton(
              mainButtonType: MainButtonType.light,
              text: "아니요".tr,
              onPressed: (){quitable = false;Get.back();},
            ),
          )
      );
    }

    if(quitable){
      LoadingUtil.withLoadingOverlay(asyncFunction: () async {
        print("really leaving this chatroom..");
        chattingRoomListController.leaveChattingRoom(chattingRoom);
      });
    }


  }

  @override
  Future<void> onInit() async {
    super.onInit();

  }

  @override
  void onReady() {
    super.onReady();
    print("before refresh");
    onRefresh(); // call refresh once at the beginning to update..
    print("after refresh");
  }


}