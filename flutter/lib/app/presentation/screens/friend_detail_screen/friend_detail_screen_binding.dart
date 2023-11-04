import 'package:get/instance_manager.dart';
import 'package:mobile_app/app/data/repository_implements/chatting_repository_impl.dart';
import 'package:mobile_app/app/domain/use_cases/request_chatting_use_case.dart';
import 'friend_detail_screen_controller.dart';

class FriendDetailScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(
      FriendDetailScreenController(
        requestChattingUseCase: RequestChattingUseCase(
          chattingRepository: ChattingRepositoryImpl(),
        ),
      ),
    );
  }
}
