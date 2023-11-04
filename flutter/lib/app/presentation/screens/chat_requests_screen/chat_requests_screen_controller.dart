import 'package:get/get.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'package:mobile_app/app/presentation/screens/main_screen/main_indexed_screen_controller.dart';

import '../../../domain/models/chatting_room.dart';

class ChatRequestsScreenController extends GetxController{

  final FetchChatroomsUseCase _fetchChatroomsUseCase;
  final chatrooms = <ChattingRoom>[].obs;

  ChatRequestsScreenController({
    required FetchChatroomsUseCase fetchChatroomsUseCase,
  }) : _fetchChatroomsUseCase = fetchChatroomsUseCase;

  void onBrowseFriendsButtonTap() {
    Get.back();
    Get.find<MainIndexedScreenController>().currentIndex(0);
  }

  @override
  void onReady() {
    super.onReady();
    _fetchChatroomsUseCase.requested(
        whenSuccess: (List<ChattingRoom> chatrooms) {
          this.chatrooms(chatrooms);
        },
        whenFail: () => {
          print("fail...")
        });
  }


}