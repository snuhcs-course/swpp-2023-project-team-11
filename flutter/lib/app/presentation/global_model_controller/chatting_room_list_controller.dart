import 'dart:async';
import 'dart:convert';
import 'dart:ffi';

import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chat.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/accept_chatting_request_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/disconnect_chatting_channel_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_all_chat_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/leave_chatting_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/open_chat_connection_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/send_chat_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_controller.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/main.dart';

class ChattingRoomListController extends GetxController
    with StateMixin<({List<ChattingRoom> roomForMain, List<ChattingRoom> roomForRequested})> {
  StreamSubscription? _centerChatStreamSubscription;
  List<ChattingRoom> _validRooms = [];

  List<ChattingRoom> _requestingRooms = [];
  List<ChattingRoom> _terminatedRooms = [];
  List<ChattingRoom> _requestedRooms = [];

  int get numRequestedRooms => _requestedRooms.length;

  @override
  Future<void> onReady() async {
    super.onReady();
    change(null, status: RxStatus.loading());
    await _fetchChattingRoomsUseCase.all(
      email: Get.find<UserController>().userEmail,
      whenSuccess: (
        validRooms,
        terminatedRooms,
        requestingRooms,
        requestedRooms,
      ) async {
        if (_centerChatStreamSubscription == null) {
          await _openChatConnection();
        }
        _updateRoomsOnlyForNewOnes(
          validRooms: validRooms,
          terminatedRooms: terminatedRooms,
          requestingRooms: requestingRooms,
          requestedRooms: requestedRooms,
        );
      },
      whenFail: () {
        print("채팅룸 불러오기 실패...");
      },
    );
  }

  Future<void> _openChatConnection() async {
    print("use case 호출해서 session 열기");
    _centerChatStreamSubscription = await _openChatConnectionUseCase.call(onReceiveChat: (chat) {
      print("receive");
      // for each chat, find the chatroom (should be a valid one) and put the chat in that chatroom.
      final targetRoomController = Get.find<ValidChattingRoomController>(
        tag: chat.chattingRoomId.toString(),
      );
      targetRoomController.addChat(chat);
    });
  }

  bool checkSp(int chatRoomId){
    return sp.containsKey(chatRoomId.toString());
  }

  void _updateRoomsOnlyForNewOnes({
    List<ChattingRoom>? validRooms,
    List<ChattingRoom>? terminatedRooms,
    List<ChattingRoom>? requestingRooms,
    List<ChattingRoom>? requestedRooms,
  }) {
    if (validRooms != null) {
      _injectDependencyForAddedValidRooms(validRooms);
      _removeDependencyForRemovedValidRooms(validRooms);

      // sort the valid rooms according to their datetime of most recent chat
      validRooms.sort((ChattingRoom room1, ChattingRoom room2){
        if(!checkSp(room1.id) || !checkSp(room2.id)) {
          print("not in sp yet!");
          return 0;
        }
        DateTime dateTime1 = Chat.fromJson(json.decode(sp.getString(room1.id.toString())!)).sentAt;
        DateTime dateTime2 = Chat.fromJson(json.decode(sp.getString(room2.id.toString())!)).sentAt;
        return dateTime2.compareTo(dateTime1);
      });
      _validRooms = validRooms;
      print("valid room, ${_validRooms.length}개");
    }
    if (requestingRooms != null) {
      _requestingRooms = requestingRooms;
      print("requestingRooms, ${_requestingRooms.length}개");
    }
    if (terminatedRooms != null) {
      _terminatedRooms = terminatedRooms;
      print("terminatedRooms, ${_terminatedRooms.length}개");
    }
    if (requestedRooms != null) {
      _requestedRooms = requestedRooms;
      print("requestedRooms, ${_requestedRooms.length}개");
    }
    change(
      (
        roomForMain: [..._validRooms, ..._requestingRooms, ..._terminatedRooms],
        roomForRequested: [..._requestedRooms]
      ),
      status: RxStatus.success(),
    );
  }

  void _injectDependencyForAddedValidRooms(List<ChattingRoom> newValidChattingRooms) {
    print('inject');
    // add a controller for a chatroom if it is not already present (the chatroom should be a valid one)
    for (final newChattingRoom in newValidChattingRooms) {
      Get.put<ValidChattingRoomController>(
          ValidChattingRoomController(
            chattingRoom: newChattingRoom,
            fetchAllChatUseCase: _fetchAllChatUseCase,
          ),
          tag: newChattingRoom.id.toString(),
          permanent: true);
    }
  }

  void _removeDependencyForRemovedValidRooms(List<ChattingRoom> newValidChattingRooms) {
    // after fetching chatrooms, if it is different from original list of chatrooms, it means we need to remove some.
    for (final priorChattingRoom in _validRooms) {
      final priorOneExistsInNewOnes =
          newValidChattingRooms.any((element) => element.id == priorChattingRoom.id);
      if (!priorOneExistsInNewOnes) {
        Get.delete<ValidChattingRoomController>(tag: priorChattingRoom.id.toString(), force: true);
      }
    }
  }

  Future<void> reloadRooms() async {
    change(null, status: RxStatus.loading());
    await _fetchChattingRoomsUseCase.all(
      email: Get.find<UserController>().userEmail,
      whenSuccess: (validRooms, terminatedRooms, requestingRooms, requestedRooms) {
        print("fetch 채팅룸 성공 in reloadRooms");
        _updateRoomsOnlyForNewOnes(
          validRooms: validRooms,
          terminatedRooms: terminatedRooms,
          requestingRooms: requestingRooms,
          requestedRooms: requestedRooms,
        );
      },
      whenFail: () {
        print("채팅룸 불러오기 실패...");
      },
    );
  }

  Future<void> acceptChattingRequest(ChattingRoom chattingRoom) async {
    await _acceptChattingRequestUseCase.call(
      chattingRoomId: chattingRoom.id,
      whenSuccess: (chattingRoom) {
        print("accept success");
        // TODO 이거 refetch 안하고 최적화 하려면 로컬 메모리에서 처리
        _updateRoomsOnlyForNewOnes(validRooms: [chattingRoom, ..._validRooms]);
      },
      whenFail: () {
        print("accept 실패");
      },
    );
    await reloadRooms();
  }

  Future<void> leaveChattingRoom(ChattingRoom chattingRoom) async {
    await _leaveChattingRoomUseCase.call(
      chattingRoomId: chattingRoom.id,
      whenSuccess: (chattingRoom) {
        print("Successfully terminated the chatroom");
        _updateRoomsOnlyForNewOnes();
      },
      whenFail: () {
        print("terminate 실패");
      },
    );
    await reloadRooms();
  }

  void deleteAllValidChattingRoomDependency() async {
    await _centerChatStreamSubscription!.cancel();
    _disconnectChattingChannelUseCase.call();
    _centerChatStreamSubscription = null;
    _validRooms.forEach((chatRoom) {
      Get.delete<ValidChattingRoomController>(tag: chatRoom.id.toString(), force: true);
    });
  }

  final AcceptChattingRequestUseCase _acceptChattingRequestUseCase;
  final FetchChattingRoomsUseCase _fetchChattingRoomsUseCase;
  final OpenChatConnectionUseCase _openChatConnectionUseCase;
  final FetchAllChatUseCase _fetchAllChatUseCase;
  final LeaveChattingRoomUseCase _leaveChattingRoomUseCase;
  final DisconnectChattingChannelUseCase _disconnectChattingChannelUseCase;

  ChattingRoomListController(
      {required FetchChattingRoomsUseCase fetchChattingRoomsUseCase,
      required AcceptChattingRequestUseCase acceptChattingRequestUseCase,
      required OpenChatConnectionUseCase openChatConnectionUseCase,
      required FetchAllChatUseCase fetchAllChatUseCase,
      required DisconnectChattingChannelUseCase disconnectChattingChannelUseCase,
      required LeaveChattingRoomUseCase leaveChattingRoomUseCase})
      : _fetchChattingRoomsUseCase = fetchChattingRoomsUseCase,
        _acceptChattingRequestUseCase = acceptChattingRequestUseCase,
        _fetchAllChatUseCase = fetchAllChatUseCase,
        _openChatConnectionUseCase = openChatConnectionUseCase,
        _disconnectChattingChannelUseCase = disconnectChattingChannelUseCase,
        _leaveChattingRoomUseCase = leaveChattingRoomUseCase;
}
