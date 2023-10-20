import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';

class ChattingRoomsScreenController extends GetxController{

  final FetchChatroomsUseCase _fetchChatroomsUseCase;
  final chatrooms = <ChattingRoom>[].obs;

  ChattingRoomsScreenController({
    required FetchChatroomsUseCase fetchChatroomsUseCase,
  }) : _fetchChatroomsUseCase = fetchChatroomsUseCase;

  @override
  Future<void> onInit() async {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    _fetchChatroomsUseCase(
        whenSuccess: (List<ChattingRoom> chatrooms) {
          this.chatrooms(chatrooms);
        },
        whenFail: () => {});
  }

}