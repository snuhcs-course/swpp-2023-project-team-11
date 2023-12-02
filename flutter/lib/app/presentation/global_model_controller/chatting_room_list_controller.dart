import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mobile_app/app/data/service_implements/chatting_service_impl.dart';
import 'package:mobile_app/app/domain/models/chat.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/models/intimacy.dart';
import 'package:mobile_app/app/domain/use_cases/accept_chatting_request_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/disconnect_chatting_channel_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_all_chat_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/leave_chatting_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/open_chat_connection_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/update_intimacy_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_controller.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';
import 'package:mobile_app/core/constants/system_strings.dart';
import 'package:mobile_app/core/themes/color_theme.dart';
import 'package:mobile_app/core/utils/loading_util.dart';
import 'package:mobile_app/main.dart';

class ChattingRoomListController extends SuperController<
    ({List<ChattingRoom> roomForMain, List<ChattingRoom> roomForRequested})> {
  StreamSubscription? _centerChatStreamSubscription;
  List<ChattingRoom> _validRooms = [];

  List<ChattingRoom> _requestingRooms = [];
  List<ChattingRoom> _terminatedRooms = [];
  List<ChattingRoom> _requestedRooms = [];

  int get numRequestedRooms => _requestedRooms.length;

  late bool isDeviceConnected = true;

  late final StreamSubscription<InternetConnectionStatus>
      isDeviceConnectedSubscription;

  late Completer _internetOverlayCompleter;

  @override
  void onInit() async {
    super.onInit();
    isDeviceConnected = await InternetConnectionChecker().hasConnection;
    print("isDeviceConnected : $isDeviceConnected");
    isDeviceConnectedSubscription = InternetConnectionChecker()
        .onStatusChange
        .listen((InternetConnectionStatus status) async {
      final newIsDeviceConnected =
          (status == InternetConnectionStatus.connected);
      print("newIsDeviceConnected : $newIsDeviceConnected");
      if (!newIsDeviceConnected) {
        _internetOverlayCompleter = Completer();
        Get.showOverlay(
          asyncFunction: () async {
            await _internetOverlayCompleter.future;
          },
          loadingWidget: Material(
            color: Colors.white70,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("인터넷 연결이 끊겼습니다"),
                CupertinoActivityIndicator(),
              ],
            ),
          )
        );
      } else {
        _internetOverlayCompleter.complete();
      }
      // 끊겼다가 다시 연결되는 경우
      if (newIsDeviceConnected && !isDeviceConnected) {
        print("// 끊겼다가 다시 연결되는 경우 -> refetch");
        reFetchAllChatsForEachValidRooms();
      }
      isDeviceConnected = newIsDeviceConnected;
    });
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    print("onReady");
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
    _centerChatStreamSubscription = await _openChatConnectionUseCase.call(
      onReceiveChat: (chat) async {
        // for each chat, find the chatroom (should be a valid one) and put the chat in that chatroom
        final bool validRoomForChatExists = _validRooms
            .where((element) => element.id == chat.chattingRoomId)
            .isNotEmpty;
        if (!validRoomForChatExists) {
          await reloadRooms();
          Fluttertoast.showToast(
              msg: chat.senderName + "님과의 첫 채팅이 도착했어요!".tr,
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.TOP,
              timeInSecForIosWeb: 1,
              backgroundColor: MyColor.orange_1,
              textColor: Colors.white,
              fontSize: 15.0);
          return;
        }

        final targetRoomController = Get.find<ValidChattingRoomController>(
          tag: chat.chattingRoomId.toString(),
        );
        targetRoomController.addChat(chat);

        if (checkIntimacyUpdateCondition(chat)) {
          sp.setString("${chat.chattingRoomId}/lastIntimacyUpdate",
              DateTime.timestamp().toString());
          _updateIntimacyUseCase.call(
              chattingRoomId: chat.chattingRoomId,
              whenSuccess: (Intimacy intimacy) {
                sp.setDouble(
                    "${chat.chattingRoomId}/${lastUpdatedIntimacyValue}",
                    intimacy.intimacy);
              },
              whenFail: () {});
        }

        sp.setString(chat.chattingRoomId.toString(), json.encode(chat));
        // need to change : 이렇게 하니까 순서는 안 바뀌긴 하네요 !!!
        change(
          (
            roomForMain: [
              ..._validRooms,
              ..._requestingRooms,
              ..._terminatedRooms
            ],
            roomForRequested: [..._requestedRooms]
          ),
          status: RxStatus.success(),
        );
        // need to check number of chat. To be used for updating intimacy

        if (checkIntimacyUpdateCondition(chat)) {
          sp.setString("${chat.chattingRoomId}/lastIntimacyUpdate",
              DateTime.timestamp().toString());
          _updateIntimacyUseCase.call(
              chattingRoomId: chat.chattingRoomId,
              whenSuccess: (Intimacy intimacy) {},
              whenFail: () {});
        }
      },
    );
  }

  bool checkIntimacyUpdateCondition(Chat chat) {
    int numChat = sp.containsKey("${chat.chattingRoomId}/numChat")
        ? sp.getInt("${chat.chattingRoomId}/numChat")!
        : 0;
    sp.setInt("${chat.chattingRoomId}/numChat", numChat + 1);
    DateTime lastIntimacyUpdateTimeStamp =
        sp.containsKey("${chat.chattingRoomId}/lastIntimacyUpdate")
            ? DateTime.parse(
                sp.getString("${chat.chattingRoomId}/lastIntimacyUpdate")!)
            : DateTime.timestamp();

    // return true when this is 1st, 21st, ... chat to the chatroom after listening
    // return true when this chat is more than 2 minutes later than the last update
    if (numChat % 20 == 0) return true;
    if (DateTime.timestamp()
            .difference(lastIntimacyUpdateTimeStamp)
            .compareTo(const Duration(minutes: 2)) >
        0) {
      return true;
    }
    return false;
  }

  bool checkSp(int chatRoomId) {
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
      validRooms.sort((ChattingRoom room1, ChattingRoom room2) {
        if (!checkSp(room1.id) || !checkSp(room2.id)) {
          return 0;
        }
        DateTime dateTime1 =
            Chat.fromJson(json.decode(sp.getString(room1.id.toString())!))
                .sentAt;
        DateTime dateTime2 =
            Chat.fromJson(json.decode(sp.getString(room2.id.toString())!))
                .sentAt;
        return dateTime2.compareTo(dateTime1);
      });
      _validRooms = validRooms;
    }
    if (requestingRooms != null) {
      _requestingRooms = requestingRooms;
    }
    if (terminatedRooms != null) {
      _terminatedRooms = terminatedRooms;
    }
    if (requestedRooms != null) {
      _requestedRooms = requestedRooms;
    }
    change(
      (
        roomForMain: [..._validRooms, ..._requestingRooms, ..._terminatedRooms],
        roomForRequested: [..._requestedRooms]
      ),
      status: RxStatus.success(),
    );
  }

  void _injectDependencyForAddedValidRooms(
      List<ChattingRoom> newValidChattingRooms) {
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

  void _removeDependencyForRemovedValidRooms(
      List<ChattingRoom> newValidChattingRooms) {
    // after fetching chatrooms, if it is different from original list of chatrooms, it means we need to remove some.
    for (final priorChattingRoom in _validRooms) {
      final priorOneExistsInNewOnes = newValidChattingRooms
          .any((element) => element.id == priorChattingRoom.id);
      if (!priorOneExistsInNewOnes) {
        Get.delete<ValidChattingRoomController>(
            tag: priorChattingRoom.id.toString(), force: true);
      }
    }
  }

  Future<void> reloadRooms() async {
    change(null, status: RxStatus.loading());
    await _fetchChattingRoomsUseCase.all(
      email: Get.find<UserController>().userEmail,
      whenSuccess:
          (validRooms, terminatedRooms, requestingRooms, requestedRooms) {
        _updateRoomsOnlyForNewOnes(
          validRooms: validRooms,
          terminatedRooms: terminatedRooms,
          requestingRooms: requestingRooms,
          requestedRooms: requestedRooms,
        );
      },
      whenFail: () {},
    );
  }

  Future<void> acceptChattingRequest(ChattingRoom chattingRoom) async {
    await _acceptChattingRequestUseCase.call(
      chattingRoomId: chattingRoom.id,
      whenSuccess: (chattingRoom) {
        // TODO 이거 refetch 안하고 최적화 하려면 로컬 메모리에서 처리
        _updateRoomsOnlyForNewOnes(validRooms: [chattingRoom, ..._validRooms]);
      },
      whenFail: () {},
    );
    await reloadRooms();
  }

  Future<void> leaveChattingRoom(ChattingRoom chattingRoom) async {
    await _leaveChattingRoomUseCase.call(
      chattingRoomId: chattingRoom.id,
      whenSuccess: (chattingRoom) {
        _updateRoomsOnlyForNewOnes();
      },
      whenFail: () {},
    );
    await reloadRooms();
  }

  void deleteAllValidChattingRoomDependency() async {
    await _centerChatStreamSubscription!.cancel();
    _disconnectChattingChannelUseCase.call();
    _centerChatStreamSubscription = null;
    for (var chatRoom in _validRooms) {
      Get.delete<ValidChattingRoomController>(
          tag: chatRoom.id.toString(), force: true);
    }
  }

  Future<void> reFetchAllChatsForEachValidRooms() async {
    final futures = _validRooms.map(
      (room) async =>
          await Get.find<ValidChattingRoomController>(tag: room.id.toString())
              .reFetchChatsFromResume(),
    );
    await Future.wait(futures);
  }

  final AcceptChattingRequestUseCase _acceptChattingRequestUseCase;
  final FetchChattingRoomsUseCase _fetchChattingRoomsUseCase;
  final OpenChatConnectionUseCase _openChatConnectionUseCase;
  final FetchAllChatUseCase _fetchAllChatUseCase;
  final LeaveChattingRoomUseCase _leaveChattingRoomUseCase;
  final DisconnectChattingChannelUseCase _disconnectChattingChannelUseCase;
  final UpdateIntimacyUseCase _updateIntimacyUseCase;

  ChattingRoomListController(
      {required FetchChattingRoomsUseCase fetchChattingRoomsUseCase,
      required AcceptChattingRequestUseCase acceptChattingRequestUseCase,
      required OpenChatConnectionUseCase openChatConnectionUseCase,
      required FetchAllChatUseCase fetchAllChatUseCase,
      required DisconnectChattingChannelUseCase
          disconnectChattingChannelUseCase,
      required LeaveChattingRoomUseCase leaveChattingRoomUseCase,
      required UpdateIntimacyUseCase updateIntimacyUseCase})
      : _fetchChattingRoomsUseCase = fetchChattingRoomsUseCase,
        _acceptChattingRequestUseCase = acceptChattingRequestUseCase,
        _fetchAllChatUseCase = fetchAllChatUseCase,
        _openChatConnectionUseCase = openChatConnectionUseCase,
        _disconnectChattingChannelUseCase = disconnectChattingChannelUseCase,
        _leaveChattingRoomUseCase = leaveChattingRoomUseCase,
        _updateIntimacyUseCase = updateIntimacyUseCase;

  @override
  void onClose() {
    super.onClose();
    isDeviceConnectedSubscription.cancel();
  }

  @override
  void onDetached() {
    print("onDetached");
  }

  @override
  void onInactive() {
    print("onInactive");
  }

  @override
  void onPaused() {
    print("onPaused");
  }

  @override
  void onResumed() async {
    print("------- on Resumed ---------");
    await reFetchAllChatsForEachValidRooms();
    await ChattingServiceImpl().reConnect();
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }
}
