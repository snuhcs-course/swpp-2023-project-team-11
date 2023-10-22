import 'package:get/instance_manager.dart';
import 'package:mobile_app/app/data/repository_implements/mock/chatting_room_repository_mock.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'chat_requests_screen_controller.dart';

class ChatRequestsScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ChatRequestsScreenController(
      fetchChatroomsUseCase: FetchChatroomsUseCase(chattingRepository: ChattingRepositoryMock())
    ));
  }
}