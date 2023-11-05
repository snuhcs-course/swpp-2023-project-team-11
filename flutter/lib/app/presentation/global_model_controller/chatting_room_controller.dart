import 'dart:ffi';

import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chat.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/open_chat_connection_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/send_chat_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';

class ValidChattingRoomController extends GetxController {
  final ChattingRoom chattingRoom;

  final SendChatUseCase _sendChatUseCase;

  final chatVmList = <ChatVM>[].obs;

  ValidChattingRoomController({
    required this.chattingRoom,
    required SendChatUseCase sendChatUseCase,
  }) : _sendChatUseCase = sendChatUseCase;

  void addChat(Chat chat) {
    final userEmail = Get.find<UserController>().userEmail;
    chatVmList.add(
      ChatVM(
        senderType: userEmail == chat.senderEmail ?SenderType.me : SenderType.you,
        text: chat.message,
        createdAt: chat.sentAt,
        sequenceId: chat.seqId,
      ),
    );
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
