import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';

class RoomScreenController extends GetxController{

  final ChattingRoom chattingRoom = Get.arguments as ChattingRoom;
  String get userEmail => Get.find<UserController>().userEmail;
  final ScrollController scrollCon = ScrollController();
  final TextEditingController chattingCon = TextEditingController();
  final enableSendButton = false.obs;
  final chatTextList = <ChatVM>[].obs;

  String get chattingRoomTitle {
   if (userEmail == chattingRoom.initiator.email) {
     return chattingRoom.responder.name;
   } else {
     return chattingRoom.initiator.name;
   }
  }

  void onSendButtonTap() {

  }
}

class ChatVM {
  final SenderType senderType;
  final String text;
  final DateTime createdAt;
  final int sequenceId;

  const ChatVM({
    required this.senderType,
    required this.text,
    required this.createdAt,
    required this.sequenceId,
  });
}