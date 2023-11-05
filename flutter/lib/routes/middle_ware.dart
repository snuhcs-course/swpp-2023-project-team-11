import 'package:get/get.dart';
import 'package:mobile_app/app/data/repository_implements/chatting_repository_impl.dart';
import 'package:mobile_app/app/data/service_implements/auth_service_impl.dart';
import 'package:mobile_app/app/data/service_implements/chatting_service_impl.dart';
import 'package:mobile_app/app/domain/models/user.dart';
import 'package:mobile_app/app/domain/use_cases/accept_chatting_request_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/open_chat_connection_use_case.dart';
import 'package:mobile_app/app/domain/use_cases/send_chat_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_list_controller.dart';
import 'package:mobile_app/app/presentation/global_model_controller/user_controller.dart';

class MainMiddleWare extends GetMiddleware {
  @override
  List<Bindings>? onBindingsStart(List<Bindings>? bindings) {
    User user = Get.arguments as User;
    Get.put<UserController>(UserController(user: user));
    final ChattingRepositoryImpl chattingRepositoryImpl = ChattingRepositoryImpl();
    final ChattingServiceImpl chattingServiceImpl = ChattingServiceImpl();
    Get.put<ChattingRoomListController>(
      ChattingRoomListController(
          fetchChattingRoomsUseCase: FetchChattingRoomsUseCase(
            chattingRepository: chattingRepositoryImpl,
          ),
          acceptChattingRequestUseCase: AcceptChattingRequestUseCase(
            chattingRepository: chattingRepositoryImpl,
          ),
          openChatConnectionUseCase: OpenChatConnectionUseCase(
            chattingService: ChattingServiceImpl(),
            authService: AuthServiceImpl(),
          ),
          sendChatUseCase: SendChatUseCase(
            chattingService: chattingServiceImpl,
          )),
    );

    return super.onBindingsStart(bindings);
  }
}