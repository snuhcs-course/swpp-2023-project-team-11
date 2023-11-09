import 'dart:ffi';

import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chat.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_all_chat_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/open_chat_connection_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/send_chat_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/app/presentation/screens/room_screen/room_screen_controller.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';

class ValidChattingRoomController extends GetxController {
  final ChattingRoom chattingRoom;
  final FetchAllChatUseCase _fetchAllChatUseCase;

  final chatVmList = <ChatVM>[].obs;

  void addChat(Chat chat) {
    final userEmail = Get.find<UserController>().userEmail;
    chatVmList.add(
      ChatVM(
        senderType: userEmail == chat.senderEmail ? SenderType.me : SenderType.you,
        text: chat.message,
        createdAt: chat.sentAt,
        sequenceId: chat.seqId,
      ),
    );
    if (Get.currentRoute =="/main/room" ) {
      print("scroll down listen");
      Future.delayed(const Duration(milliseconds: 100)).then((value) => Get.find<RoomScreenController>().scrollDownToBottom());
    }
  }

  @override
  void onInit() {
    super.onInit();
    _fetchAllChatUseCase.call(
      chattingRoomId: chattingRoom.id.toString(),
      whenSuccess: (chats) {
        print("fetch all");
        final userEmail = Get.find<UserController>().userEmail;
        chatVmList.addAll(chats.map((chat) => ChatVM(
          senderType: userEmail == chat.senderEmail ? SenderType.me : SenderType.you,
          text: chat.message,
          createdAt: chat.sentAt,
          sequenceId: chat.seqId,
        )));
      },
      whenFail: () {},
    );
  }

  ValidChattingRoomController({
    required this.chattingRoom,
    required FetchAllChatUseCase fetchAllChatUseCase,
  }) : _fetchAllChatUseCase = fetchAllChatUseCase;
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
