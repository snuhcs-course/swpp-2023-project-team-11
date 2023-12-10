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

  void addChat(Chat chat, {bool proxyMode = false}) {
    final userEmail = Get.find<UserController>().userEmail;
    final receivedChatSenderType =
    chat.senderEmail == userEmail ? SenderType.me : SenderType.you;
    if (proxyMode) {
      final tempChatVm = ChatVM.fromChat(chat, temp: true);
      // 화면에 추가하기 - 임시 버전으로 바로 추가하기
      chatVmList.add(
        tempChatVm,
      );
      Future.delayed(const Duration(milliseconds: 2000)).then((value) {
        // 2초 지난 뒤에도 temp이면 삭제 활성화
        if (tempChatVm.temp) {
          final target = chatVmList.lastWhere((chatVm) =>
          chatVm.text == chat.message &&
              chatVm.senderType == receivedChatSenderType);
          tempChatVm.needsDelete = true;
          // view 다시 그리기
          chatVmList.refresh();
        }
      });
    } else {
      // proxyMode가 아닐 때, 즉 소켓에서 왔을 때
      // final alreadyAddedProxyTarget = chatVmList.firstWhereOrNull((chatVm) =>
      //     chatVm.text == chat.message &&
      //         chatVm.temp &&
      //     chatVm.senderType == receivedChatSenderType );
      final alreadyAddedProxyTarget = chatVmList.firstWhereOrNull((vm) => chat.proxyId == vm.proxyId);
      if (alreadyAddedProxyTarget!=null) {
        alreadyAddedProxyTarget.updateTemp(sequenceId: chat.seqId, temp: false);
        chatVmList.refresh();
      } else {
        chatVmList.add(ChatVM.fromChat(chat));
      }


    }
    if (Get.currentRoute == "/main/room") {
      Future.delayed(const Duration(milliseconds: 100)).then(
          (value) => Get.find<RoomScreenController>().scrollDownToBottom());
    }
  }

  void deleteChat(int seqId) {
    final target =
        chatVmList.firstWhere((element) => element.sequenceId == seqId);
    chatVmList.remove(target);
  }

  int _getLatestChatIndex() {
    for (int i = chatVmList.length-1; i >= 0; i--) {
      final target = chatVmList[i].sequenceId;
      if (target < 0) {
        continue;
      }
      return i;
    }
    return chatVmList.length;
  }

  Future<void> reFetchChatsFromResume() async {
    final lastChatIndex = _getLatestChatIndex();
    await _fetchAllChatUseCase.call(
      chattingRoomId: chattingRoom.id.toString(),
      sequenceId: chatVmList[lastChatIndex].sequenceId,
      whenSuccess: (chats) {
        chatVmList.insertAll(
          lastChatIndex +1,
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
        if (chats.isNotEmpty)
          sp.setString(chattingRoom.id.toString(),
              json.encode(chats.last)); // 여기서 업데이트 하는데 왜 그럴까요 !!!
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
  final int proxyId;
  bool temp;
  bool needsDelete;

  ChatVM._({
    required this.senderType,
    required this.text,
    required this.createdAt,
    required this.sequenceId,
    required this.proxyId,
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
      proxyId: chat.proxyId,
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
    int? proxyId,
    bool? temp,
  }) {
    return ChatVM._(
      senderType: senderType ?? this.senderType,
      text: text ?? this.text,
      createdAt: createdAt ?? this.createdAt,
      sequenceId: sequenceId ?? this.sequenceId,
      temp: temp ?? this.temp,
      proxyId: proxyId ?? this.proxyId,
    );
  }
}
