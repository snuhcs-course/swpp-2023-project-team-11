import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_list_controller.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'package:mobile_app/routes/named_routes.dart';

class ChattingRoomsScreenController extends GetxController{

  final Rxn<bool> newChatRequestExists = Rxn(null); // 새로운 채팅 요청 여부에 따라 업데이트 돼어야함


  final ChattingRoomListController chattingRoomController = Get.find<ChattingRoomListController>();
  final UserController userController = Get.find<UserController>();


  void onNewChatRequestTap() {
    Get.toNamed(Routes.Maker(nextRoute: Routes.CHAT_REQUESTS));
  }

  void onChattingRoomTap(ChattingRoom chattingRoom) {
    if (chattingRoom.isApproved) {
      Get.toNamed(Routes.Maker(nextRoute: Routes.ROOM), arguments: chattingRoom);
    } else {
      Fluttertoast.showToast(
          msg: "수락되지 않은 채팅방입니다",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: MyColor.orange_1,
          textColor: Colors.white,
          fontSize: 15.0
      );
    }
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    newChatRequestExists.value = true;
  }


}