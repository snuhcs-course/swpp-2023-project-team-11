import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/send_chat_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_controller.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';
import 'package:mobile_app/routes/named_routes.dart';

class RoomScreenController extends GetxController {
  final SendChatUseCase _sendChatUseCase;

  final ChattingRoom chattingRoom = Get.arguments as ChattingRoom;

  final FocusNode chattingFocusNode = FocusNode();

  late final ValidChattingRoomController validChattingRoomController =
      Get.find<ValidChattingRoomController>(
    tag: chattingRoom.id.toString(),
  );

  void scrollDownToBottom([int? milliseconds]) {
    scrollCon.animateTo(scrollCon.position.maxScrollExtent,
        duration: Duration(milliseconds: milliseconds?? 200), curve: Curves.linear);
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

  void onSnekiTap() {
    Get.toNamed(Routes.Maker(nextRoute: Routes.ROADMAP), arguments: chattingRoom);
  }

  @override
  void onInit() {
    super.onInit();
    chattingCon.addListener(() {
      enableSendButton(chattingCon.text.isNotEmpty);
    });
    chattingFocusNode.addListener(() async {
      print(chattingFocusNode.hasFocus);
      if (chattingFocusNode.hasFocus) {
        await Future.delayed(const Duration(milliseconds: 160));
        scrollDownToBottom(110);
        await Future.delayed(const Duration(milliseconds: 110));
        scrollDownToBottom(50);
      } else {

      }
    });
  }

  @override
  void onReady() async {
    super.onReady();
    scrollCon.jumpTo(scrollCon.position.maxScrollExtent);
    await Future.delayed(const Duration(milliseconds: 60));
    scrollCon.jumpTo(scrollCon.position.maxScrollExtent);
  }

  @override
  void onClose() {
    super.onClose();
    chattingCon.dispose();
    chattingFocusNode.dispose();
  }

  RoomScreenController({
    required SendChatUseCase sendChatUseCase,
  }) : _sendChatUseCase = sendChatUseCase;
}
