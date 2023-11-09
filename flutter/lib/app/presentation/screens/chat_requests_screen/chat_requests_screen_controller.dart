import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/use_cases/accept_chatting_request_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_list_controller.dart';
import 'package:mobile_app/app/presentation/screens/chat_requests_screen/widgets/user_info_detail_bottom_sheet.dart';
import 'package:mobile_app/app/presentation/screens/main_screen/main_indexed_screen_controller.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'package:mobile_app/core/utils/loading_util.dart';

import '../../../domain/models/chatting_room.dart';

class ChatRequestsScreenController extends GetxController {
  final ChattingRoomListController chattingRoomListController =
      Get.find<ChattingRoomListController>();
  final requestable = true.obs;

  Future<void> onAcceptButtonTap(ChattingRoom chattingRoom) async {
    LoadingUtil.withLoadingOverlay(asyncFunction: () async  {
      await chattingRoomListController.acceptChattingRequest(chattingRoom);
    });

  }

  void onProfileTap(User you, ChattingRoom chattingRoom) {
    // need to display profile details of this user
    Get.bottomSheet(UserInfoDetailBottomSheet(
      onAcceptButtonTap: () async {
        requestable.value = false;
        Get.back();
        await onAcceptButtonTap(chattingRoom);
        Fluttertoast.showToast(
            msg: "채팅 요청이 수락되었어요. 채팅 목록에서 확인할 수 있어요!",
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: MyColor.orange_1,
            textColor: Colors.white,
            fontSize: 15.0);
      },
      user: you,
    ));

  }

  void onBrowseFriendsButtonTap() {
    Get.back();
    Get.find<MainIndexedScreenController>().currentIndex(0);
  }
}
