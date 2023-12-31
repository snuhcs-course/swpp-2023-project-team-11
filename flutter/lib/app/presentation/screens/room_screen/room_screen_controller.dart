import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chat.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/send_chat_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_controller.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/core/utils/proxy_id_generator.dart';
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
        duration: Duration(milliseconds: milliseconds ?? 200),
        curve: Curves.linear);
  }

  String get userEmail => Get.find<UserController>().userEmail;

  String get userName => Get.find<UserController>().userName;
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

  int tempSeqId = -1;

  String get opponentEmail {
    if (userEmail == chattingRoom.initiator.email) {
      return chattingRoom.responder.email;
    } else {
      return chattingRoom.initiator.email;
    }
  }

  void onSendButtonTap() {
    final proxyId = ProxyIdGenerator.getByNowTime();
    _sendChatUseCase.call(
      chatText: chattingCon.text,
      chattingRoomId: chattingRoom.id.toString(),
      proxyId: proxyId,
    );
    // 프록시를 위한 코드
    Get.find<ValidChattingRoomController>(
      tag: chattingRoom.id.toString(),
    ).addChat(
      Chat(
        seqId: tempSeqId--,
        chattingRoomId: chattingRoom.id,
        senderName: userName,
        senderEmail: userEmail,
        message: chattingCon.text,
        sentAt: DateTime.now(),
        proxyId: proxyId,
      ),
      proxyMode: true,
    );
    chattingCon.text = "";
  }

  void onChatDeleteButtonTap(int seqId) {
    Get.find<ValidChattingRoomController>(
      tag: chattingRoom.id.toString(),
    ).deleteChat(seqId);
  }

  void onSnekiTap() {
    // Get.put<RoomScreenController>(
    //   RoomScreenController(sendChatUseCase: _sendChatUseCase),
    //   tag: this.chattingRoom.id.toString()
    // );
    Get.toNamed(Routes.Maker(nextRoute: Routes.ROADMAP),
        arguments: chattingRoom);
  }

  @override
  void onInit() {
    super.onInit();
    chattingCon.addListener(() {
      enableSendButton(chattingCon.text.isNotEmpty);
    });
    chattingFocusNode.addListener(() async {
      if (chattingFocusNode.hasFocus) {
        await Future.delayed(const Duration(milliseconds: 160));
        scrollDownToBottom(110);
        await Future.delayed(const Duration(milliseconds: 110));
        scrollDownToBottom(50);
      } else {}
    });
  }

  @override
  void onReady() async {
    super.onReady();
    scrollCon.jumpTo(scrollCon.position.maxScrollExtent);
    await Future.delayed(const Duration(milliseconds: 60));
    scrollCon.jumpTo(scrollCon.position.maxScrollExtent);
    await Future.delayed(const Duration(milliseconds: 40));
    scrollCon.jumpTo(scrollCon.position.maxScrollExtent);
    // scrollCon.animateTo(
    //   scrollCon.position.maxScrollExtent,
    //   duration: const Duration(milliseconds: 100),
    //   curve: Curves.linear,
    // );
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
