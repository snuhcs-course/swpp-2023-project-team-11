import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';

class ChattingRoomController extends GetxController
    with StateMixin<({List<ChattingRoom> roomForMain, List<ChattingRoom> roomForReqeusted})> {

  late final List<ChattingRoom> _validRooms;
  late final List<ChattingRoom> _terminatedRooms;
  late final List<ChattingRoom> _requestedRooms;

  @override
  void onReady() async {
    super.onReady();
    change(null, status: RxStatus.loading());
    await _fetchChattingRoomsUseCase.all(
      email: Get.find<UserController>().userEmail,
      whenSuccess: (validRooms, terminatedRooms, requestedRooms) {
        print("fetch 채팅룸 성공");
        _validRooms = validRooms;
        _terminatedRooms = terminatedRooms;
        _requestedRooms = requestedRooms;

        change((roomForMain: [..._validRooms, ..._terminatedRooms], roomForReqeusted: [..._requestedRooms]), status: RxStatus.success());
      },
      whenFail: () {
        print("채팅룸 불러오기 실패...");
      },
    );
  }

  final FetchChattingRoomsUseCase _fetchChattingRoomsUseCase;

  ChattingRoomController({
    required FetchChattingRoomsUseCase fetchChattingRoomsUseCase,
  }) : _fetchChattingRoomsUseCase = fetchChattingRoomsUseCase;
}
