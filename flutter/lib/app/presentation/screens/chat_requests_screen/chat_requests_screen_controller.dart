import 'package:get/get.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';

import '../../../domain/models/chatting_room.dart';

class ChatRequestsScreenController extends GetxController{

  final FetchChatroomsUseCase _fetchChatroomsUseCase;
  final chatrooms = <ChattingRoom>[].obs;

  ChatRequestsScreenController({
    required FetchChatroomsUseCase fetchChatroomsUseCase,
  }) : _fetchChatroomsUseCase = fetchChatroomsUseCase;

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