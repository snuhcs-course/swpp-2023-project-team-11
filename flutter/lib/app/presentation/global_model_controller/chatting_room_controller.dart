import 'dart:convert';

import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chat.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_all_chat_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/app/presentation/screens/room_screen/room_screen_controller.dart';
import 'package:mobile_app/app/presentation/widgets/chat_messages.dart';
import 'package:mobile_app/main.dart';

class ValidChattingRoomController extends GetxController {
  final ChattingRoom chattingRoom;
  final FetchAllChatUseCase _fetchAllChatUseCase;

  final chatVmList = <ChatVM>[].obs;

  void addChat(Chat chat, [bool proxyMode = false]) {
    final userEmail = Get.find<UserController>().userEmail;
    if (proxyMode) {
      final tempChatVm = ChatVM.fromChat(chat, temp: true);
      chatVmList.add(
        tempChatVm,
      );
      Future.delayed(const Duration(milliseconds: 2000)).then((value) {
        if (tempChatVm.temp) {
          chatVmList.last.needsDelete = true;
          chatVmList.refresh();
        }
      });
    } else {
      if (chatVmList.last.temp) {
        if (chatVmList.last.text == chat.message &&
            chatVmList.last.senderType ==
                (userEmail == chat.senderEmail ? SenderType.me : SenderType.you)) {
          chatVmList.last.updateTemp(sequenceId: chat.seqId, temp: false);
          chatVmList.refresh();
          return;
        }
      }
      chatVmList.add(ChatVM.fromChat(chat));
    }
    if (Get.currentRoute == "/main/room") {
      print("scroll down listen");
      Future.delayed(const Duration(milliseconds: 100))
          .then((value) => Get.find<RoomScreenController>().scrollDownToBottom());
    }
  }

  void deleteChat(int seqId) {
    final target = chatVmList.firstWhere((element) => element.sequenceId == seqId);
    chatVmList.remove(target);
  }

  int _getLatestChatIndex() {
    for (int i = chatVmList.length - 1; i >= 0; i--) {
      final target = chatVmList[i].sequenceId;
      if (target < 0) {
        continue;
      }
      return chatVmList[i].sequenceId;
    }
    return chatVmList.length;
  }

  void reFetchChatsFromResume() {
    _fetchAllChatUseCase.call(
      chattingRoomId: chattingRoom.id.toString(),
      sequenceId: chatVmList[_getLatestChatIndex()].sequenceId,
      whenSuccess: (chats) {
        chatVmList.insertAll(
          _getLatestChatIndex(),
          chats.map((e) => ChatVM.fromChat(e)),
        );
      },
      whenFail: () {},
    );
  }

  @override
  void onInit() {
    super.onInit();
    _fetchAllChatUseCase.call(
      chattingRoomId: chattingRoom.id.toString(),
      whenSuccess: (chats) {
        print("fetch all");
        if (chats.isNotEmpty) sp.setString(chattingRoom.id.toString(), json.encode(chats.last)); // 여기서 업데이트 하는데 왜 그럴까요 !!!
        // print("${sp.getString(chattingRoom.id.toString())} is what i found from sp - encoding");
        // final userEmail = Get.find<UserController>().userEmail;
        chatVmList.addAll(chats.map((chat) => ChatVM.fromChat(chat)));
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
  int sequenceId;
  bool temp;
  bool needsDelete;

  ChatVM._({
    required this.senderType,
    required this.text,
    required this.createdAt,
    required this.sequenceId,
    this.temp = false,
    this.needsDelete = false,
  });

  factory ChatVM.fromChat(Chat chat, {bool temp = false}) {
    final myEmail = Get.find<UserController>().userEmail;
    return ChatVM._(
      senderType: chat.senderEmail == myEmail ? SenderType.me : SenderType.you,
      text: chat.message,
      createdAt: chat.sentAt,
      sequenceId: chat.seqId,
      temp: temp,
    );
  }

  void updateTemp({required int sequenceId, required bool temp}) {
    this.sequenceId = sequenceId;
    this.temp = temp;
  }

  ChatVM copyWith({
    SenderType? senderType,
    String? text,
    DateTime? createdAt,
    int? sequenceId,
    bool? temp,
  }) {
    return ChatVM._(
      senderType: senderType ?? this.senderType,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      sequenceId: sequenceId ?? this.sequenceId,
      temp: temp ?? this.temp,
    );
  }
}
