import 'dart:ffi';

import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/accept_chatting_request_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_all_chat_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/open_chat_connection_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/send_chat_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_controller.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';

class ChattingRoomListController extends GetxController
    with StateMixin<({List<ChattingRoom> roomForMain, List<ChattingRoom> roomForRequested})> {
  Stream? _centerChatStream;
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
        if (validRooms.isNotEmpty && _centerChatStream == null) {
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
    _centerChatStream = await _openChatConnectionUseCase.call(onReceiveChat: (chat) {
      print("receive");
      // for each chat, find the chatroom (should be a valid one) and put the chat in that chatroom.
      final targetRoomController = Get.find<ValidChattingRoomController>(
        tag: chat.chattingRoomId.toString(),
      );
      targetRoomController.addChat(chat);
    });
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
    // add a controller for a chatroom if it is not already present (the chatroom should be a valid one)
    for (final newChattingRoom in newValidChattingRooms) {
      final newOneAlreadyExisted = _validRooms.any((element) => element.id == newChattingRoom.id);
      if (!newOneAlreadyExisted) {
        Get.put<ValidChattingRoomController>(
          ValidChattingRoomController(
            chattingRoom: newChattingRoom,
            fetchAllChatUseCase: _fetchAllChatUseCase,
          ),
          tag: newChattingRoom.id.toString(),
        );
      }
    }
  }

  void _removeDependencyForRemovedValidRooms(List<ChattingRoom> newValidChattingRooms) {
    // after fetching chatrooms, if it is different from original list of chatrooms, it means we need to remove some.
    for (final priorChattingRoom in _validRooms) {
      final priorOneExistsInNewOnes =
          newValidChattingRooms.any((element) => element.id == priorChattingRoom.id);
      if (!priorOneExistsInNewOnes) {
        Get.delete<ValidChattingRoomController>(tag: priorChattingRoom.id.toString());
      }
    }
  }

  Future<void> reloadRooms() async {
    change(null, status: RxStatus.loading());
    await _fetchChattingRoomsUseCase.all(
      email: Get.find<UserController>().userEmail,
      whenSuccess: (validRooms, terminatedRooms, requestingRooms, requestedRooms) {
        print("fetch 채팅룸 성공");
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
        _updateRoomsOnlyForNewOnes();
      },
      whenFail: () {
        print("accept 실패");
      },
    );
    await reloadRooms();
  }

  final AcceptChattingRequestUseCase _acceptChattingRequestUseCase;
  final FetchChattingRoomsUseCase _fetchChattingRoomsUseCase;
  final OpenChatConnectionUseCase _openChatConnectionUseCase;
  final FetchAllChatUseCase _fetchAllChatUseCase;

  ChattingRoomListController({
    required FetchChattingRoomsUseCase fetchChattingRoomsUseCase,
    required AcceptChattingRequestUseCase acceptChattingRequestUseCase,
    required OpenChatConnectionUseCase openChatConnectionUseCase,
    required FetchAllChatUseCase fetchAllChatUseCase,
  })  : _fetchChattingRoomsUseCase = fetchChattingRoomsUseCase,
        _acceptChattingRequestUseCase = acceptChattingRequestUseCase,
        _fetchAllChatUseCase = fetchAllChatUseCase,
        _openChatConnectionUseCase = openChatConnectionUseCase;
}
