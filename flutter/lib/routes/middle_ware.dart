import 'package:get/get.dart';
import 'package:mobile_app/app/data/repository_implements/chatting_repository_impl.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_controller.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';

class MainMiddleWare extends GetMiddleware {
  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    User user = Get.arguments as User;
    Get.put<UserController>(UserController(user: user));
    Get.put<ChattingRoomController>(
      ChattingRoomController(
        fetchChattingRoomsUseCase: FetchChattingRoomsUseCase(
          chattingRepository: ChattingRepositoryImpl(),
        ),
      ),
    );

    return super.onBindingsStart(bindings);
  }
}
