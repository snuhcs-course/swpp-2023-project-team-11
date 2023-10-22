import 'package:get/instance_manager.dart';
import 'package:mobile_app/app/data/repository_implements/mock/chatting_room_repository_mock.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'chatting_rooms_screen_controller.dart';

class ChattingRoomsScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(ChattingRoomsScreenController(
        fetchChatroomsUseCase: FetchChatroomsUseCase(
            chattingRepository: ChattingRepositoryMock())));
  }
}
