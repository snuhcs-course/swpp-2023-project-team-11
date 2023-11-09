import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/send_chat_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_controller.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';

class RoomScreenController extends GetxController {
  final SendChatUseCase _sendChatUseCase;

  final ChattingRoom chattingRoom = Get.arguments as ChattingRoom;

  late final ValidChattingRoomController validChattingRoomController =
      Get.find<ValidChattingRoomController>(
    tag: chattingRoom.id.toString(),
  );

  void scrollDownToBottom() {
    scrollCon.animateTo(scrollCon.position.maxScrollExtent, duration: const Duration(milliseconds: 200), curve: Curves.linear);
  }



  String get userEmail => Get.find<UserController>().userEmail;
  final ScrollController scrollCon = ScrollController();
  final TextEditingController chattingCon = TextEditingController();
  final enableSendButton = false.obs;

  String get chattingRoomTitle {
    if (userEmail == chattingRoom.initiator.email) {
      return chattingRoom.responder.name;
    } else {
      return chattingRoom.initiator.name;
    }
  }

  void onSendButtonTap() {
    _sendChatUseCase.call(chatText: chattingCon.text, chattingRoomId: chattingRoom.id.toString());
    chattingCon.text = "";
  }

  @override
  void onInit() {
    super.onInit();
    chattingCon.addListener(() {
      enableSendButton(chattingCon.text.isNotEmpty);
    });
  }
  @override
  void onReady() {
    super.onReady();
    scrollCon.jumpTo(scrollCon.position.maxScrollExtent);
  }

  @override
  void onClose() {
    super.onClose();
    chattingCon.dispose();
  }

  RoomScreenController({
    required SendChatUseCase sendChatUseCase,
  }) : _sendChatUseCase = sendChatUseCase;
}

