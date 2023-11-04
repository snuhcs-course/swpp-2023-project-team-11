import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/accept_chatting_request_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';

class ChattingRoomController extends GetxController
    with StateMixin<({List<ChattingRoom> roomForMain, List<ChattingRoom> roomForRequested})> {
  late List<ChattingRoom> _validRooms = [];
  late List<ChattingRoom> _terminatedRooms = [];
  late List<ChattingRoom> _requestedRooms = [];

  @override
  void onReady() async {
    super.onReady();
    change(null, status: RxStatus.loading());
    await _fetchChattingRoomsUseCase.all(
      email: Get
          .find<UserController>()
          .userEmail,
      whenSuccess: (validRooms, terminatedRooms, requestedRooms) {
        print("fetch 채팅룸 성공");
        _updateRoomsOnlyForNewOnes(
          validRooms: validRooms,
          terminatedRooms: terminatedRooms,
          requestedRooms: requestedRooms,
        );
      },
      whenFail: () {
        print("채팅룸 불러오기 실패...");
      },
    );
  }

  void _updateRoomsOnlyForNewOnes({
    List<ChattingRoom>? validRooms,
    List<ChattingRoom>? terminatedRooms,
    List<ChattingRoom>? requestedRooms,
  }) {
    print("try update local chatting room state");
    if (validRooms != null) {
      _validRooms = validRooms;
    }
    if (terminatedRooms != null) {
      _terminatedRooms = terminatedRooms;
    }
    if (requestedRooms != null) {
      _requestedRooms = requestedRooms;
    }
    change((
    roomForMain: [..._validRooms, ..._terminatedRooms],
    roomForRequested: [..._requestedRooms]
    ), status: RxStatus.success(),);
  }

  Future<void> reloadRooms() async {
    change(null, status: RxStatus.loading());
    await _fetchChattingRoomsUseCase.all(
      email: Get
          .find<UserController>()
          .userEmail,
      whenSuccess: (validRooms, terminatedRooms, requestedRooms) {
        print("fetch 채팅룸 성공");
        _updateRoomsOnlyForNewOnes(
          validRooms: validRooms,
          terminatedRooms: terminatedRooms,
          requestedRooms: requestedRooms,
        );
      },
      whenFail: () {
        print("채팅룸 불러오기 실패...");
      },
    );
  }

  void acceptChattingRequest(ChattingRoom chattingRoom) async {
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

  ChattingRoomController({
    required FetchChattingRoomsUseCase fetchChattingRoomsUseCase,
    required AcceptChattingRequestUseCase acceptChattingRequestUseCase,
  })
      : _fetchChattingRoomsUseCase = fetchChattingRoomsUseCase,
        _acceptChattingRequestUseCase = acceptChattingRequestUseCase;
}
