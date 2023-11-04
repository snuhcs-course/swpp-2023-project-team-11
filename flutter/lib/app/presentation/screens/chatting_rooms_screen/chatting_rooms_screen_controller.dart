import 'package:get/get.dart';
import 'package:mobile_app/app/domain/models/chatting_room.dart';
import 'package:mobile_app/app/domain/use_cases/fetch_chatrooms_use_case.dart';
import 'package:mobile_app/app/presentation/global_model_controller/chatting_room_controller.dart';
import 'package:mobile_app/routes/named_routes.dart';

class ChattingRoomsScreenController extends GetxController{

  final Rxn<bool> newChatRequestExists = Rxn(null); // 새로운 채팅 요청 여부에 따라 업데이트 돼어야함


  final ChattingRoomController chattingRoomController = Get.find<ChattingRoomController>();



  void onNewChatRequestTap() {
    Get.toNamed(Routes.Maker(nextRoute: Routes.CHAT_REQUESTS));
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    newChatRequestExists.value = true;
  }


}