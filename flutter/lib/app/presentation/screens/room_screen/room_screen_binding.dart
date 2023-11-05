import 'package:get/instance_manager.dart';
import 'package:mobile_app/app/data/service_implements/chatting_service_impl.dart';
import 'package:mobile_app/app/domain/use_cases/send_chat_use_case.dart';
import 'room_screen_controller.dart';

class RoomScreenBinding implements Bindings {
  @override
  void dependencies() {
    Get.put(RoomScreenController(
      sendChatUseCase: SendChatUseCase(chattingService: ChattingServiceImpl())
    ));
  }
}