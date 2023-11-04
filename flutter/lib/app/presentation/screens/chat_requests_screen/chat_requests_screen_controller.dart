import 'package:get/get.dart';
import 'package:mobile_app/app/domain/use_cases/accept_chatting_request_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_controller.dart';
import 'package:mobile_app/app/presentation/screens/main_screen/main_indexed_screen_controller.dart';

import '../../../domain/models/chatting_room.dart';

class ChatRequestsScreenController extends GetxController{
  final ChattingRoomController chattingRoomController = Get.find<ChattingRoomController>();


  void onAcceptButtonTap(ChattingRoom chattingRoom) {
    chattingRoomController.acceptChattingRequest(chattingRoom);
  }

  void onBrowseFriendsButtonTap() {
    Get.back();
    Get.find<MainIndexedScreenController>().currentIndex(0);
  }
}